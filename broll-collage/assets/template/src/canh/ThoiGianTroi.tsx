// CANH: thoi gian troi / mat thoi gian / lam thu cong cham
// Mach: giay nen -> dong ho roi xuong, kim quay nhanh dan -> to lich bay roi
//       -> dong cat chay -> dau X do dong xuong (mat thoi gian)
import React from "react";
import { interpolate, spring, useVideoConfig } from "remotion";
import { Piece, TamGiay, HatNhan, usePop, useQFrame, ACCENT, POP, CREAM, INK } from "../chatlieu";

export const ThoiGianTroi: React.FC<{ wide: boolean; square: boolean }> = ({ wide, square }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();

  // kim dong ho: quay cham roi nhanh dan (thoi gian tuot khoi tay)
  const tick = frame > 30 ? Math.pow(Math.max(0, frame - 30) / 100, 1.7) * 900 : 0;
  const kimPhut = tick;
  const kimGio = tick / 12;

  const x = usePop(104, 118); // dau X chot

  // Bo cuc rieng theo huong khung (thu nho ban doc thi to lich + cat troi lo
  // lung ngoai giay, dau X de len mep giay).
  const P = wide
    ? {
        giay: { x: 200, y: 110, w: 1520, h: 860 },
        dongHo: { x: 600, y: 520, r: 1 },
        lich: [{ x: 1000, y: 300 }, { x: 1180, y: 430 }, { x: 1360, y: 330 }],
        cat: { x: 1120, y: 640, day: 900 },
        x: { x: 1620, y: 830 },
        hat: [{ d: 92, x: 300, y: 250, c: ACCENT, r: 18 }, { d: 112, x: 1700, y: 260, c: CREAM, r: 13 }],
      }
    : square
    ? {
        giay: { x: 120, y: 120, w: 840, h: 800 },
        dongHo: { x: 420, y: 420, r: 0.86 },
        lich: [{ x: 700, y: 250 }, { x: 760, y: 480 }, { x: 640, y: 700 }],
        cat: { x: 420, y: 760, day: 990 },
        x: { x: 900, y: 900 },
        hat: [{ d: 92, x: 140, y: 900, c: ACCENT, r: 16 }, { d: 112, x: 960, y: 180, c: CREAM, r: 13 }],
      }
    : {
        giay: { x: 230, y: 300, w: 620, h: 1180 },
        dongHo: { x: 540, y: 640, r: 1 },
        lich: [{ x: 290, y: 1010 }, { x: 470, y: 1120 }, { x: 640, y: 1050 }],
        cat: { x: 540, y: 1300, day: 1790 },
        x: { x: 830, y: 1530 },
        hat: [{ d: 92, x: 250, y: 560, c: ACCENT, r: 18 }, { d: 112, x: 300, y: 1520, c: CREAM, r: 13 }],
      };

  return (
    <>
      <g>
        {/* giay nen CAO, phu ca vung to lich phia duoi (khong de trong nua khung) */}
        <TamGiay x={P.giay.x} y={P.giay.y} w={P.giay.w} h={P.giay.h} />

        {/* dong ho tron halftone */}
        <Piece delay={16} seed={2} fromY={-460} rotEnd={-2} bobAmp={5}>
          <g transform={`translate(${P.dongHo.x} ${P.dongHo.y}) scale(${P.dongHo.r})`}>
            <circle r="196" fill="url(#halftone)" stroke={INK} strokeWidth="8" />
            <circle r="164" fill={CREAM} stroke={INK} strokeWidth="6" />
            {/* vach gio */}
            {Array.from({ length: 12 }).map((_, i) => {
              const a = (i / 12) * Math.PI * 2;
              const r1 = 132, r2 = 152;
              return (
                <line key={i}
                  x1={Math.sin(a) * r1} y1={-Math.cos(a) * r1}
                  x2={Math.sin(a) * r2} y2={-Math.cos(a) * r2}
                  stroke={INK} strokeWidth={i % 3 === 0 ? 9 : 5} strokeLinecap="round" />
              );
            })}
            {/* kim */}
            <g transform={`rotate(${kimGio})`}>
              <rect x="-9" y="-92" width="18" height="102" rx="9" fill={INK} />
            </g>
            <g transform={`rotate(${kimPhut})`}>
              <rect x="-7" y="-140" width="14" height="150" rx="7" fill={POP} />
            </g>
            <circle r="16" fill={INK} />
            {/* num tren dinh */}
            <rect x="-22" y="-214" width="44" height="26" rx="8" fill="url(#halftone)" stroke={INK} strokeWidth="6" />
          </g>
        </Piece>
      </g>

      <g>
        {/* 3 to lich bay roi - moi to roi mot nhip */}
        {P.lich.map((L2, i) => {
          const t = { d: [44, 58, 72][i], x: L2.x, y: L2.y, r: [-14, 9, -6][i], s: [3, 4, 5][i] };
          const sp = spring({ frame: frame - t.d, fps, config: { damping: 11, stiffness: 90 } });
          const roi = interpolate(sp, [0, 1], [0, 120 + i * 40]);
          const nghieng = interpolate(sp, [0, 1], [t.r, t.r + 22]);
          const mo = interpolate(frame - t.d, [0, 6, 60, 78], [0, 1, 1, 0.35], {
            extrapolateLeft: "clamp", extrapolateRight: "clamp",
          });
          return (
            <g key={i} transform={`translate(${t.x} ${t.y + roi}) rotate(${nghieng})`} opacity={mo}
               style={{ filter: "url(#softshadow)" }}>
              <g filter="url(#tornSmall)">
                <rect x="0" y="0" width="150" height="180" rx="6" fill={CREAM} stroke={INK} strokeWidth="5" />
                <rect x="0" y="0" width="150" height="46" fill={POP} />
                {/* so ngay bang vach giay, khong dung chu */}
                <rect x="34" y="82" width="82" height="14" rx="7" fill={INK} opacity="0.8" />
                <rect x="34" y="112" width="58" height="14" rx="7" fill={INK} opacity="0.55" />
              </g>
            </g>
          );
        })}

        {/* dong cat chay lien tuc xuong day khung - giu chuyen dong den cuoi clip */}
        {Array.from({ length: 20 }).map((_, i) => {
          const bd = 50 + i * 4;
          if (frame < bd) return null;
          const t = ((frame - bd) % 52) / 52; // chay vong lai, khong dut dong
          return (
            <circle key={i} cx={P.cat.x + Math.sin(i * 1.7 + frame * 0.02) * 26} cy={P.cat.y + t * (P.cat.day - P.cat.y)}
              r={9 - t * 4} fill={ACCENT} opacity={(0.9 - t * 0.55) * 0.9} />
          );
        })}
        {/* dong cat da doi duoi day */}
        <ellipse cx={P.cat.x} cy={P.cat.day} rx={interpolate(Math.min(1, Math.max(0, frame - 70) / 70), [0, 1], [0, 170])}
                 ry={interpolate(Math.min(1, Math.max(0, frame - 70) / 70), [0, 1], [0, 40])}
                 fill={ACCENT} opacity="0.75" />
      </g>

      <g>
        {/* dau X do: chot y "thoi gian mat roi" */}
        <g transform={`translate(${P.x.x} ${P.x.y}) scale(${x.scale}) rotate(${x.rot})`} opacity={x.opacity}
           style={{ filter: "url(#softshadow)" }}>
          <circle r="78" fill={POP} />
          <circle r="78" fill="none" stroke={CREAM} strokeWidth="7" />
          <path d="M-30 -30 L30 30 M30 -30 L-30 30" stroke={CREAM} strokeWidth="16" strokeLinecap="round" />
        </g>
        <HatNhan diem={P.hat} />
      </g>
    </>
  );
};
