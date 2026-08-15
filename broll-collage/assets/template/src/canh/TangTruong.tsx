// CANH: tang truong / doanh thu / ket qua di len
// Mach: giay nen -> 4 cot bieu do moc len so le -> mui ten leo qua dinh cac cot
//       -> dong xu nay len o dinh
import React from "react";
import { interpolate, spring, useVideoConfig } from "remotion";
import { Piece, TamGiay, HatNhan, usePop, useQFrame, ACCENT, POP, CREAM, INK } from "../chatlieu";

export const TangTruong: React.FC<{ wide: boolean; square: boolean }> = ({ wide, square }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  const xu = usePop(106, 120);

  // Bo cuc rieng theo huong khung (thu nho ban doc thi cot tran ra ngoai giay,
  // dong xu bay tit goc, nua phai trong hoac).
  const P = wide
    ? {
        giay: { x: 200, y: 110, w: 1520, h: 860 },
        day: 880, rong: 150,
        cot: [
          { x: 400, cao: 200 }, { x: 640, cao: 330 },
          { x: 880, cao: 470 }, { x: 1120, cao: 620 },
        ],
        xu: { x: 1480, y: 300 },
        hat: [{ d: 96, x: 300, y: 250, c: CREAM, r: 15 }, { d: 116, x: 1660, y: 800, c: ACCENT, r: 17 }],
      }
    : square
    ? {
        giay: { x: 120, y: 120, w: 840, h: 800 },
        day: 830, rong: 120,
        cot: [
          { x: 250, cao: 180 }, { x: 420, cao: 300 },
          { x: 590, cao: 430 }, { x: 760, cao: 570 },
        ],
        xu: { x: 900, y: 190 },
        hat: [{ d: 96, x: 150, y: 200, c: CREAM, r: 14 }, { d: 116, x: 960, y: 900, c: ACCENT, r: 16 }],
      }
    : {
        giay: { x: 230, y: 330, w: 620, h: 1180 },
        day: 1300, rong: 104,
        cot: [
          { x: 300, cao: 230 }, { x: 440, cao: 380 },
          { x: 580, cao: 540 }, { x: 720, cao: 730 },
        ],
        xu: { x: 830, y: 520 },
        hat: [{ d: 96, x: 250, y: 520, c: CREAM, r: 15 }, { d: 116, x: 300, y: 1560, c: ACCENT, r: 17 }],
      };

  const DAY = P.day;
  const COT = P.cot.map((c, i) => ({ ...c, delay: 22 + i * 10 }));

  // mui ten leo qua dinh cac cot: ve dan theo stroke-dash
  const veTen = spring({ frame: frame - 70, fps, config: { damping: 20, stiffness: 55 } });
  const nua = P.rong / 2;
  const TEN_D =
    `M${COT[0].x - 20} ${DAY - COT[0].cao + 50} ` +
    COT.map((c) => `L${c.x + nua} ${DAY - c.cao - 10}`).join(" ");

  return (
    <>
      <g>
        <TamGiay x={P.giay.x} y={P.giay.y} w={P.giay.w} h={P.giay.h} />

        {/* truc day */}
        <Piece delay={14} seed={2} fromX={-260} rotEnd={0}>
          <rect x={P.cot[0].x - 50} y={DAY} width={P.cot[3].x - P.cot[0].x + P.rong + 100} height="12" rx="6" fill={INK} opacity="0.8" />
        </Piece>

        {/* 4 cot moc len */}
        {COT.map((c, i) => {
          const s = spring({ frame: frame - c.delay, fps, config: { damping: 13, mass: 0.9, stiffness: 130 } });
          const h = interpolate(s, [0, 1], [0, c.cao]);
          const nhun = frame > c.delay + 26 ? Math.sin((frame - c.delay) * 0.11 + i) * 3 : 0;
          return (
            <g key={i} style={{ filter: "url(#softshadow)" }} opacity={s > 0.02 ? 1 : 0}>
              <g filter="url(#tornSmall)">
                <rect x={c.x} y={DAY - h + nhun} width={P.rong} height={h} rx="6"
                      fill={i === COT.length - 1 ? ACCENT : "url(#halftone)"}
                      stroke={INK} strokeWidth="5" />
              </g>
              {/* vach ke tren cot cho ra chat giay in */}
              {h > 90 && (
                <rect x={c.x + P.rong * 0.22} y={DAY - h + 26 + nhun} width={P.rong * 0.55} height="10" rx="5"
                      fill={CREAM} opacity="0.5" />
              )}
            </g>
          );
        })}

        {/* mui ten leo qua dinh cot */}
        <g style={{ filter: "url(#softshadow)" }}>
          <path d={TEN_D} stroke={POP} strokeWidth="18" fill="none" strokeLinecap="round" strokeLinejoin="round"
                pathLength={1000} strokeDasharray={1000} strokeDashoffset={1000 * (1 - veTen)} />
          {veTen > 0.92 && (
            <g transform={`translate(${P.cot[3].x + P.rong / 2} ${DAY - P.cot[3].cao - 10}) rotate(-50)`}>
              <path d="M0 -34 L30 12 L-30 12 Z" fill={POP} />
            </g>
          )}
        </g>
      </g>

      <g>
        {/* dong xu nay len o dinh */}
        <g transform={`translate(${P.xu.x} ${P.xu.y}) scale(${xu.scale}) rotate(${xu.rot})`} opacity={xu.opacity}
           style={{ filter: "url(#softshadow)" }}>
          <circle r="72" fill={ACCENT} stroke={INK} strokeWidth="6" />
          <circle r="52" fill="none" stroke={INK} strokeWidth="5" opacity="0.6" />
          <rect x="-8" y="-34" width="16" height="68" rx="8" fill={INK} opacity="0.85" />
          <rect x="-26" y="-12" width="52" height="12" rx="6" fill={INK} opacity="0.85" />
        </g>
        <HatNhan diem={P.hat} />
      </g>
    </>
  );
};
