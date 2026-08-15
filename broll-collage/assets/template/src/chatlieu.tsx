// ============================================================
// CHAT LIEU DUNG CHUNG cho moi canh collage.
// Them canh moi -> import tu day, KHONG chep lai.
// ============================================================
import React from "react";
import { useCurrentFrame, useVideoConfig, spring, interpolate } from "remotion";

// ---- Mau: 3 mau doi duoc tu ngoai (CSS var), 3 mau chat lieu co dinh ----
export const BG = "var(--bg)";
export const ACCENT = "var(--accent)";
export const POP = "var(--pop)";
export const CREAM = "#f3ead6";
export const CREAM_EDGE = "#ddd0af";
export const INK = "#1d1b1a";

// ---- Thoi gian co gian + nhip stop-motion ----
// Moi moc trong canh viet tren THANG CHUAN 150 khung. Ham nay quy doi khung
// that -> khung chuan, nen clip dai bao nhieu cung chay tron cau chuyen.
export const BASE = 150;
export const useQFrame = () => {
  const f = useCurrentFrame();
  const { durationInFrames } = useVideoConfig();
  const scaled = f * (BASE / Math.max(1, durationInFrames));
  return Math.floor(scaled / 2) * 2; // luong hoa 15fps = chat stop-motion
};

// ---- Rung tay giay (gia ngau nhien on dinh, doi moi 4 khung) ----
const pr = (seed: number) => {
  const x = Math.sin(seed * 127.1) * 43758.5453;
  return x - Math.floor(x);
};
export const jit = (frame: number, seed: number, amp: number) => {
  const step = Math.floor(frame / 4);
  return (pr(step * 7.13 + seed) - 0.5) * 2 * amp;
};

// ---- Bezier bac 3 (dat vat bam dung duong cong) ----
export const cubic = (t: number, a: number, b: number, c: number, d: number) => {
  const m = 1 - t;
  return m * m * m * a + 3 * m * m * t * b + 3 * m * t * t * c + t * t * t * d;
};
export const cubicD = (t: number, a: number, b: number, c: number, d: number) => {
  const m = 1 - t;
  return 3 * m * m * (b - a) + 6 * m * t * (c - b) + 3 * t * t * (d - c);
};

// ============================================================
// Piece - mieng giay cat dan: lo xo truot vao + rung tay + bob nhe.
// Moi mieng PHAI co seed rieng, khong thi rung giong het nhau (lo chieu).
// ============================================================
export const Piece: React.FC<{
  delay: number;
  seed: number;
  fromX?: number;
  fromY?: number;
  rotEnd?: number;
  bobAmp?: number;
  children: React.ReactNode;
}> = ({ delay, seed, fromX = 0, fromY = 300, rotEnd = 0, bobAmp = 0, children }) => {
  const frame = useQFrame();
  const { fps, width: W, height: H } = useVideoConfig();
  // Xoay quanh TAM KHUNG THAT (khong phai tam co dinh 540x960) - neu khong,
  // o khung ngang moi mieng se bi hat lech ra ngoai.
  const cx = W / 2, cy = H / 2;
  const s = spring({ frame: frame - delay, fps, config: { damping: 12, mass: 0.9, stiffness: 120 } });
  const arrived = frame > delay + 22;
  const jx = arrived ? jit(frame, seed, 1.5) : 0;
  const jy = arrived ? jit(frame, seed + 3.7, 1.5) : 0;
  const jr = arrived ? jit(frame, seed + 9.1, 0.5) : 0;
  const bob = arrived && bobAmp ? Math.sin(frame * 0.07 + seed) * bobAmp : 0;
  const x = interpolate(s, [0, 1], [fromX, 0]) + jx;
  const y = interpolate(s, [0, 1], [fromY, 0]) + jy + bob;
  const rot = interpolate(s, [0, 1], [rotEnd - 12, rotEnd]) + jr;
  const opacity = interpolate(frame - delay, [0, 6], [0, 1], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  return (
    <g
      transform={`translate(${x} ${y}) rotate(${rot} ${cx} ${cy})`}
      opacity={opacity}
      style={{ filter: "url(#softshadow)" }}
    >
      {children}
    </g>
  );
};

// ---- Pop: bat len tai cho (dung cho mieng chot: nut play, dau tick...) ----
export const usePop = (delay: number, pulseFrom?: number) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  const s = spring({ frame: frame - delay, fps, config: { damping: 9, mass: 0.7, stiffness: 170 } });
  const pulse = pulseFrom && frame > pulseFrom ? 1 + Math.sin((frame - pulseFrom) * 0.16) * 0.035 : 1;
  const opacity = interpolate(frame - delay, [0, 5], [0, 1], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  return { scale: interpolate(s, [0, 1], [0, 1]) * pulse, rot: interpolate(s, [0, 1], [-24, 0]), opacity, s };
};

// ---- Ban tay giay: vao dat mieng chot roi rut ra ----
export const BanTay: React.FC<{ vao: number; dat: number; rut: number; x: number; y: number }> = ({
  vao, rut, x, y,
}) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  const sIn = spring({ frame: frame - vao, fps, config: { damping: 14, mass: 1, stiffness: 80 } });
  const sOut = spring({ frame: frame - rut, fps, config: { damping: 16, mass: 1, stiffness: 70 } });
  if (frame < vao - 4 || frame > rut + 40) return null;
  const dx = interpolate(sIn, [0, 1], [400, 0]) + interpolate(sOut, [0, 1], [0, 450]);
  const dy = interpolate(sIn, [0, 1], [560, 0]) + interpolate(sOut, [0, 1], [0, 430]);
  const rot = interpolate(sOut, [0, 1], [0, 16]);
  return (
    <g
      transform={`translate(${x + dx} ${y + dy}) rotate(${rot})`}
      style={{ filter: "url(#softshadow)" }}
      opacity={interpolate(frame - vao, [0, 5], [0, 1], { extrapolateLeft: "clamp", extrapolateRight: "clamp" })}
    >
      <g transform="rotate(-34)">
        <rect x="26" y="-16" width="120" height="34" rx="17" fill={CREAM} stroke={INK} strokeWidth="5" />
        <ellipse cx="196" cy="34" rx="88" ry="66" fill={CREAM} stroke={INK} strokeWidth="5" />
        <circle cx="136" cy="42" r="20" fill={CREAM} stroke={INK} strokeWidth="5" />
        <circle cx="164" cy="58" r="20" fill={CREAM} stroke={INK} strokeWidth="5" />
        <circle cx="196" cy="68" r="20" fill={CREAM} stroke={INK} strokeWidth="5" />
        <ellipse cx="150" cy="-24" rx="52" ry="22" fill={CREAM} stroke={INK} strokeWidth="5" transform="rotate(24 150 -24)" />
        <g transform="rotate(18 280 70)">
          <rect x="252" y="6" width="120" height="130" rx="8" fill="url(#halftoneLight)" stroke={INK} strokeWidth="5" />
        </g>
      </g>
    </g>
  );
};

// ---- Tam giay kem lam nen (hau het canh deu dung) ----
export const TamGiay: React.FC<{ x?: number; y?: number; w?: number; h?: number; delay?: number }> = ({
  x = 230, y = 330, w = 620, h = 820, delay = 2,
}) => (
  <Piece delay={delay} seed={1} fromY={-120} rotEnd={-3.5}>
    <g filter="url(#torn)">
      <rect x={x} y={y} width={w} height={h} rx="6" fill={CREAM_EDGE} />
      <rect x={x + 14} y={y + 14} width={w - 28} height={h - 28} rx="4" fill={CREAM} />
    </g>
  </Piece>
);

// ---- Cham nhan + sao lap lanh (rai cho do trong) ----
export const HatNhan: React.FC<{ diem: { d: number; x: number; y: number; c: string; r: number }[] }> = ({ diem }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  return (
    <>
      {diem.map((p, i) => {
        const s = spring({ frame: frame - p.d, fps, config: { damping: 10, stiffness: 200 } });
        const tw = 0.7 + 0.3 * Math.sin(frame * 0.18 + i * 2);
        return (
          <circle key={i} cx={p.x} cy={p.y} r={interpolate(s, [0, 1], [0, p.r])} fill={p.c}
            opacity={interpolate(frame - p.d, [0, 5], [0, tw], { extrapolateLeft: "clamp", extrapolateRight: "clamp" })} />
        );
      })}
    </>
  );
};

export const Sao: React.FC<{ diem: { d: number; x: number; y: number; s: number }[] }> = ({ diem }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  return (
    <>
      {diem.map((p, i) => {
        const s = spring({ frame: frame - p.d, fps, config: { damping: 9, stiffness: 220 } });
        const tw = 0.8 + 0.2 * Math.sin(frame * 0.22 + i * 3);
        return (
          <g key={i} transform={`translate(${p.x} ${p.y}) scale(${interpolate(s, [0, 1], [0, p.s]) * tw})`} opacity={s}>
            <path d="M0 -18 L5 -5 L18 0 L5 5 L0 18 L-5 5 L-18 0 L-5 -5 Z" fill={CREAM} />
          </g>
        );
      })}
    </>
  );
};

// ---- Bo loc + hoa tiet dung chung (dat 1 lan trong <defs>) ----
export const Defs: React.FC = () => (
  <defs>
    <filter id="grain">
      <feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" stitchTiles="stitch" />
      <feColorMatrix type="saturate" values="0" />
      <feComponentTransfer><feFuncA type="linear" slope="0.07" /></feComponentTransfer>
      <feComposite operator="over" in2="SourceGraphic" />
    </filter>
    <filter id="torn">
      <feTurbulence type="fractalNoise" baseFrequency="0.018" numOctaves="3" result="n" />
      <feDisplacementMap in="SourceGraphic" in2="n" scale="16" xChannelSelector="R" yChannelSelector="G" />
    </filter>
    <filter id="tornSmall">
      <feTurbulence type="fractalNoise" baseFrequency="0.04" numOctaves="2" result="n" />
      <feDisplacementMap in="SourceGraphic" in2="n" scale="8" xChannelSelector="R" yChannelSelector="G" />
    </filter>
    <filter id="softshadow" x="-40%" y="-40%" width="180%" height="180%">
      <feDropShadow dx="0" dy="14" stdDeviation="16" floodColor="#0a2b27" floodOpacity="0.3" />
    </filter>
    <pattern id="halftone" width="12" height="12" patternUnits="userSpaceOnUse">
      <rect width="12" height="12" fill="#2c2a28" />
      <circle cx="6" cy="6" r="2.7" fill="#615c57" />
    </pattern>
    <pattern id="halftoneLight" width="11" height="11" patternUnits="userSpaceOnUse">
      <rect width="11" height="11" fill={CREAM} />
      <circle cx="5.5" cy="5.5" r="2" fill="#c9b98e" />
    </pattern>
    <radialGradient id="vig" cx="50%" cy="40%" r="78%">
      <stop offset="58%" stopColor="#000" stopOpacity="0" />
      <stop offset="100%" stopColor="#000" stopOpacity="0.24" />
    </radialGradient>
    <radialGradient id="leak" cx="22%" cy="12%" r="45%">
      <stop offset="0%" stopColor="#ffd98a" stopOpacity="0.16" />
      <stop offset="100%" stopColor="#ffd98a" stopOpacity="0" />
    </radialGradient>
  </defs>
);
