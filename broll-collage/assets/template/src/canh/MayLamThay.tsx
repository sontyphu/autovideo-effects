// CANH: AI / may lam thay nguoi / tu dong hoa
// Mach: giay nen -> 3 banh rang an khop quay -> tia sang -> ban tay giay rut ve
//       (nguoi buong tay) -> nut nguon bat sang
import React from "react";
import { interpolate, spring, useVideoConfig } from "remotion";
import { Piece, TamGiay, BanTay, Sao, usePop, useQFrame, ACCENT, POP, CREAM, INK } from "../chatlieu";

const BanhRang: React.FC<{ cx: number; cy: number; r: number; rang: number; arrive: number; nguoc?: boolean; mau?: string }> =
({ cx, cy, r, rang, arrive, nguoc, mau }) => {
  const frame = useQFrame();
  // quay theo nac (stop-motion), 2 banh an khop thi quay nguoc chieu nhau
  const ang = frame > arrive ? Math.floor((frame - arrive) / 3) * (nguoc ? -6.5 : 6.5) : 0;
  const rIn = r * 0.66;
  return (
    <g transform={`rotate(${ang} ${cx} ${cy})`}>
      {Array.from({ length: rang }).map((_, i) => {
        const a = (i / rang) * Math.PI * 2;
        return (
          <rect key={i} x={cx - 15} y={cy - r - 20} width="30" height="34" rx="5"
                fill={mau ?? "url(#halftone)"} stroke={INK} strokeWidth="4"
                transform={`rotate(${(a * 180) / Math.PI} ${cx} ${cy})`} />
        );
      })}
      <circle cx={cx} cy={cy} r={r} fill={mau ?? "url(#halftone)"} stroke={INK} strokeWidth="6" />
      <circle cx={cx} cy={cy} r={rIn} fill={CREAM} stroke={INK} strokeWidth="5" />
      <circle cx={cx} cy={cy} r={r * 0.18} fill={INK} />
      {/* 3 nan hoa */}
      {[0, 1, 2].map((k) => {
        const a = (k / 3) * Math.PI * 2;
        return (
          <rect key={k} x={cx - 7} y={cy - rIn + 6} width="14" height={rIn - 16} rx="7" fill={INK} opacity="0.55"
                transform={`rotate(${(a * 180) / Math.PI} ${cx} ${cy})`} />
        );
      })}
    </g>
  );
};

export const MayLamThay: React.FC<{ wide: boolean; square: boolean }> = ({ wide, square }) => {
  const frame = useQFrame();
  const nguon = usePop(104, 118);

  // tia sang toa ra khi may chay
  const toa = frame > 78 ? Math.min(1, (frame - 78) / 24) : 0;

  // Bo cuc: khung NGANG dung toa do rieng (trai->phai), khong phai thu nho ban doc
  // (thu nho ban doc thi don het sang trai, nua phai trong hoac).
  const P = wide
    ? {
        giay: { x: 250, y: 120, w: 1420, h: 840 },
        rang: [
          { cx: 560, cy: 460, r: 150, rang: 12 },
          { cx: 862, cy: 620, r: 106, rang: 10, mau: ACCENT },
          { cx: 640, cy: 790, r: 92, rang: 10 },
          { cx: 1090, cy: 470, r: 80, rang: 9, mau: ACCENT },
        ],
        tiaX: 560, tiaY: 460,
        tay: { x: 1180, y: 700 },
        nguon: { x: 1520, y: 760 },
        sao: [{ d: 110, x: 1420, y: 220, s: 0.9 }, { d: 122, x: 240, y: 980, s: 0.7 }],
      }
    : square
    ? {
        giay: { x: 150, y: 150, w: 780, h: 780 },
        rang: [
          { cx: 420, cy: 430, r: 140, rang: 12 },
          { cx: 690, cy: 590, r: 100, rang: 10, mau: ACCENT },
          { cx: 400, cy: 730, r: 88, rang: 10 },
          { cx: 700, cy: 300, r: 74, rang: 9, mau: ACCENT },
        ],
        tiaX: 420, tiaY: 430,
        tay: { x: 700, y: 880 },
        nguon: { x: 880, y: 930 },
        sao: [{ d: 110, x: 130, y: 950, s: 0.8 }, { d: 122, x: 950, y: 180, s: 0.7 }],
      }
    : {
        giay: { x: 230, y: 300, w: 620, h: 1180 },
        rang: [
          { cx: 470, cy: 620, r: 150, rang: 12 },
          { cx: 748, cy: 800, r: 104, rang: 10, mau: ACCENT },
          { cx: 420, cy: 968, r: 96, rang: 10 },
          { cx: 676, cy: 1180, r: 78, rang: 9, mau: ACCENT },
        ],
        tiaX: 470, tiaY: 620,
        tay: { x: 640, y: 1500 },
        nguon: { x: 846, y: 1420 },
        sao: [{ d: 110, x: 250, y: 520, s: 0.9 }, { d: 122, x: 300, y: 1520, s: 0.7 }],
      };

  const VAO = [
    { delay: 18, seed: 2, fromY: -420, fromX: 0, rot: -2 },
    { delay: 30, seed: 4, fromY: 0, fromX: 300, rot: 2 },
    { delay: 42, seed: 6, fromY: 340, fromX: 0, rot: -1 },
    { delay: 52, seed: 8, fromY: 0, fromX: -320, rot: 2 },
  ];

  return (
    <>
      <g>
        <TamGiay x={P.giay.x} y={P.giay.y} w={P.giay.w} h={P.giay.h} />

        {/* 4 banh rang an khop */}
        {P.rang.map((r, i) => (
          <Piece key={i} delay={VAO[i].delay} seed={VAO[i].seed} fromX={VAO[i].fromX}
                 fromY={VAO[i].fromY} rotEnd={VAO[i].rot} bobAmp={4 - i * 0.4}>
            <BanhRang cx={r.cx} cy={r.cy} r={r.r} rang={r.rang} arrive={40 + i * 7}
                      nguoc={i % 2 === 1} mau={(r as any).mau} />
          </Piece>
        ))}

        {/* tia sang giay toa ra tu banh chinh */}
        {toa > 0 &&
          Array.from({ length: 8 }).map((_, i) => {
            const a = (i / 8) * Math.PI * 2 + 0.3;
            const nhay = 1 + Math.sin(frame * 0.12 + i) * 0.25; // giu lap lanh den cuoi clip
            const d = 200 + toa * 40;
            return (
              <rect key={i} x={P.tiaX - 7} y={P.tiaY - d} width="14" height={40 * toa * nhay} rx="7"
                    fill={CREAM} opacity={0.45 * toa}
                    transform={`rotate(${(a * 180) / Math.PI} ${P.tiaX} ${P.tiaY})`} />
            );
          })}

        {/* ban tay buong ra - "may lam thay ban": rut MUON de con thay o khung cuoi */}
        <BanTay vao={64} dat={84} rut={124} x={P.tay.x} y={P.tay.y} />

        {/* nut nguon bat sang */}
        <g transform={`translate(${P.nguon.x} ${P.nguon.y}) scale(${nguon.scale}) rotate(${nguon.rot})`}
           opacity={nguon.opacity} style={{ filter: "url(#softshadow)" }}>
          <circle r="74" fill={POP} />
          <circle r="74" fill="none" stroke={CREAM} strokeWidth="7" />
          <path d="M0 -34 A 34 34 0 1 0 22 -26" stroke={CREAM} strokeWidth="13" fill="none" strokeLinecap="round" />
          <rect x="-7" y="-42" width="14" height="34" rx="7" fill={CREAM} />
        </g>
        <Sao diem={P.sao} />
      </g>
    </>
  );
};
