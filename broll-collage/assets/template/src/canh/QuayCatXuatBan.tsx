// CANH: quay -> dung -> xuat ban (lam video, quy trinh, cac buoc)
// Mach: giay nen -> duong phim chay ra tu may quay -> dai phim -> keo cat DUT
//       -> ban tay dat nut play
import React from "react";
import { interpolate, spring, useVideoConfig } from "remotion";
import {
  Piece, TamGiay, BanTay, HatNhan, Sao, usePop, useQFrame, cubic, cubicD,
  ACCENT, POP, CREAM, INK,
} from "../chatlieu";

// Duong phim. DOC: chay xuong. NGANG: chay cheo sang phai (dai phim o ben phai).
const SEG1_V = { x: [500, 560, 400, 540], y: [740, 860, 950, 1060] };
const SEG2_V = { x: [540, 660, 520, 545], y: [1060, 1150, 1160, 1250] };
const SEG1_W = { x: [500, 610, 700, 860], y: [740, 900, 620, 790] };
const SEG2_W = { x: [860, 1010, 1180, 1330], y: [790, 950, 700, 815] };

const roadPoint = (u: number, wide: boolean) => {
  const S1 = wide ? SEG1_W : SEG1_V;
  const S2 = wide ? SEG2_W : SEG2_V;
  const seg = u < 0.5 ? S1 : S2;
  const t = u < 0.5 ? u * 2 : (u - 0.5) * 2;
  const x = cubic(t, seg.x[0], seg.x[1], seg.x[2], seg.x[3]);
  const y = cubic(t, seg.y[0], seg.y[1], seg.y[2], seg.y[3]);
  const dx = cubicD(t, seg.x[0], seg.x[1], seg.x[2], seg.x[3]);
  const dy = cubicD(t, seg.y[0], seg.y[1], seg.y[2], seg.y[3]);
  return { x, y, ang: (Math.atan2(dy, dx) * 180) / Math.PI };
};

const Reel: React.FC<{ cx: number; cy: number; r: number; arrive: number }> = ({ cx, cy, r, arrive }) => {
  const frame = useQFrame();
  const ang = frame > arrive ? -Math.floor((frame - arrive) / 3) * 7.2 : 0;
  return (
    <g transform={`rotate(${ang} ${cx} ${cy})`}>
      <circle cx={cx} cy={cy} r={r} fill="url(#halftone)" stroke={INK} strokeWidth="6" />
      {Array.from({ length: 6 }).map((_, i) => {
        const a = (i / 6) * Math.PI * 2;
        return <circle key={i} cx={cx + Math.cos(a) * r * 0.55} cy={cy + Math.sin(a) * r * 0.55} r="7" fill={INK} opacity="0.7" />;
      })}
      <circle cx={cx} cy={cy} r="14" fill={ACCENT} />
    </g>
  );
};

export const QuayCatXuatBan: React.FC<{ wide: boolean; square: boolean }> = ({ wide, square }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();

  const roadS = spring({ frame: frame - 12, fps, config: { damping: 20, mass: 1, stiffness: 40 } });
  const S1 = wide ? SEG1_W : SEG1_V;
  const S2 = wide ? SEG2_W : SEG2_V;
  const ROAD_D = `M${S1.x[0]} ${S1.y[0]} C ${S1.x[1]} ${S1.y[1]}, ${S1.x[2]} ${S1.y[2]}, ${S1.x[3]} ${S1.y[3]} C ${S2.x[1]} ${S2.y[1]}, ${S2.x[2]} ${S2.y[2]}, ${S2.x[3]} ${S2.y[3]}`;

  // keo: truot vao + 2 nhip cat
  const sSc = spring({ frame: frame - 62, fps, config: { damping: 13, stiffness: 110 } });
  const scX = interpolate(sSc, [0, 1], [430, 0]);
  const scOp = interpolate(frame - 62, [0, 6], [0, 1], { extrapolateLeft: "clamp", extrapolateRight: "clamp" });
  const snip =
    frame < 78 ? 10
    : frame < 86 ? 10 - 8 * Math.sin(((frame - 78) / 8) * Math.PI)
    : frame < 94 ? 10 - 9 * Math.sin(((frame - 86) / 8) * Math.PI)
    : 7 + 2 * Math.sin(frame * 0.06);

  // manh phai roi tach ra sau nhat cat
  const sCut = spring({ frame: frame - 90, fps, config: { damping: 11, stiffness: 90 } });
  const cutDx = interpolate(sCut, [0, 1], [0, 18]);
  const cutDy = interpolate(sCut, [0, 1], [0, 26]);
  const cutRot = interpolate(sCut, [0, 1], [0, 7]);

  const play = usePop(104, 118);
  const recOn = frame > 48 && Math.floor(frame / 12) % 2 === 0;
  const HOLE_TS = [0.08, 0.2, 0.32, 0.44, 0.56, 0.68, 0.8, 0.92];

  const L = wide
    ? { main: "translate(40 -125) scale(0.80)", strip: "translate(900 -570) scale(0.86)", play: "translate(845 -655) scale(0.95)", deco: "translate(170 60) scale(0.58)" }
    : square
    ? { main: "translate(30 -300) scale(0.86)", strip: "translate(60 -340) scale(0.92)", play: "translate(140 -430) scale(0.95)", deco: "translate(40 20) scale(0.72)" }
    : { main: "", strip: "", play: "", deco: "" };

  return (
    <>
      <g transform={L.main}>
        <TamGiay />

        {/* duong phim ve dan */}
        <g style={{ filter: "url(#softshadow)" }}>
          <path d={ROAD_D} stroke={ACCENT} strokeWidth="110" fill="none" strokeLinecap="round"
                pathLength={1000} strokeDasharray={1000} strokeDashoffset={1000 * (1 - roadS)} />
          {HOLE_TS.map((u, i) => {
            if (roadS < u + 0.06) return null;
            const p = roadPoint(u, wide);
            return (
              <g key={i} transform={`rotate(${p.ang} ${p.x} ${p.y})`} opacity="0.8">
                <rect x={p.x - 10} y={p.y - 52} width="20" height="16" rx="3" fill={INK} />
                <rect x={p.x - 10} y={p.y + 36} width="20" height="16" rx="3" fill={INK} />
              </g>
            );
          })}
        </g>

        {/* may quay */}
        <Piece delay={22} seed={2} fromY={-500} rotEnd={-2.5} bobAmp={4}>
          <g transform="translate(360 430)">
            <rect x="0" y="70" width="300" height="180" rx="18" fill="url(#halftone)" stroke={INK} strokeWidth="6" />
            <Reel cx={80} cy={55} r={62} arrive={40} />
            <Reel cx={220} cy={55} r={62} arrive={40} />
            <rect x="292" y="120" width="120" height="70" rx="10" fill="#2c2a28" stroke={INK} strokeWidth="6" />
            <circle cx="412" cy="155" r="40" fill={INK} />
            <circle cx="412" cy="155" r="40" fill="none" stroke={POP} strokeWidth="10" />
            <rect x="-26" y="150" width="34" height="14" rx="7" fill={INK} />
            <circle cx="272" cy="100" r="10" fill={POP} opacity={recOn ? 1 : 0.25} />
          </g>
        </Piece>
      </g>

      {/* dai phim + keo cat dut */}
      <g transform={L.strip}>
        <Piece delay={46} seed={3} fromX={-340} rotEnd={-3} bobAmp={3}>
          <g transform="translate(250 1180)">
            <g filter="url(#tornSmall)">
              <rect x="0" y="0" width="312" height="150" rx="4" fill={INK} />
              {Array.from({ length: 5 }).map((_, i) => (
                <g key={i}>
                  <rect x={12 + i * 58} y="8" width="20" height="16" rx="3" fill={CREAM} opacity="0.85" />
                  <rect x={12 + i * 58} y="126" width="20" height="16" rx="3" fill={CREAM} opacity="0.85" />
                </g>
              ))}
              <rect x="20" y="32" width="130" height="86" fill="url(#halftone)" />
              <rect x="168" y="32" width="130" height="86" fill="url(#halftone)" />
            </g>
            <g transform={`translate(${cutDx} ${cutDy}) rotate(${cutRot} 318 150)`} filter="url(#tornSmall)">
              <rect x="318" y="0" width="160" height="150" rx="4" fill={INK} />
              {Array.from({ length: 3 }).map((_, i) => (
                <g key={i}>
                  <rect x={330 + i * 58} y="8" width="20" height="16" rx="3" fill={CREAM} opacity="0.85" />
                  <rect x={330 + i * 58} y="126" width="20" height="16" rx="3" fill={CREAM} opacity="0.85" />
                </g>
              ))}
              <rect x="330" y="32" width="130" height="86" fill="url(#halftone)" />
            </g>
            <g transform={`translate(${scX} 0)`} opacity={scOp}>
              <g transform="translate(315 40) rotate(-24)">
                <g transform={`rotate(${-snip} 0 0)`}>
                  <path d="M0 0 L-215 -30 L-215 -12 Z" fill="#d9d6d1" stroke={INK} strokeWidth="4" />
                  <line x1="0" y1="0" x2="62" y2="-26" stroke={POP} strokeWidth="13" strokeLinecap="round" />
                  <circle cx="92" cy="-38" r="30" fill="none" stroke={POP} strokeWidth="15" />
                </g>
                <g transform={`rotate(${snip} 0 0)`}>
                  <path d="M0 0 L-215 30 L-215 12 Z" fill="#efece7" stroke={INK} strokeWidth="4" />
                  <line x1="0" y1="0" x2="62" y2="26" stroke={POP} strokeWidth="13" strokeLinecap="round" />
                  <circle cx="92" cy="38" r="30" fill="none" stroke={POP} strokeWidth="15" />
                </g>
                <circle cx="0" cy="0" r="9" fill={INK} />
              </g>
            </g>
          </g>
        </Piece>
      </g>

      {/* nut play + ban tay dat */}
      <g transform={L.play}>
        <g transform={`translate(700 1560) scale(${play.scale}) rotate(${play.rot})`} opacity={play.opacity}
           style={{ filter: "url(#softshadow)" }}>
          <circle r="80" fill={POP} />
          <circle r="80" fill="none" stroke={CREAM} strokeWidth="7" />
          <path d="M-24 -34 L38 0 L-24 34 Z" fill={CREAM} />
        </g>
        <BanTay vao={88} dat={104} rut={112} x={700} y={1560} />
      </g>

      <g transform={L.deco}>
        <HatNhan diem={[
          { d: 96, x: 250, y: 560, c: ACCENT, r: 18 },
          { d: 104, x: 845, y: 760, c: POP, r: 14 },
          { d: 112, x: 285, y: 1450, c: CREAM, r: 13 },
        ]} />
        <Sao diem={[{ d: 108, x: 870, y: 1180, s: 1 }, { d: 118, x: 210, y: 880, s: 0.7 }]} />
      </g>
    </>
  );
};
