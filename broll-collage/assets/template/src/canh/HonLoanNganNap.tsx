// CANH: hon loan -> ngan nap (kien thuc rai rac duoc sap xep lai)
// Hop voi: bo nao thu 2, quan ly tri thuc, dep dong tai lieu, he thong hoa
// Mach: giay to bay lung tung khap khung -> tu ho so hien ra giua -> giay lan
//       luot bay VAO dung ngan -> con 1 to cuoi con lo lung -> dau tick chot
import React from "react";
import { interpolate, spring, useVideoConfig } from "remotion";
import { Piece, Sao, usePop, useQFrame, ACCENT, POP, CREAM, INK } from "../chatlieu";

export const HonLoanNganNap: React.FC<{ wide: boolean; square: boolean }> = ({ wide, square }) => {
  const frame = useQFrame();
  const { fps } = useVideoConfig();
  const tick = usePop(118, 132);

  // Bo cuc rieng theo huong khung (khong thu nho ban doc - tick se bi cat day).
  const P = wide
    ? {
        tu: { x: 520, y: 230, w: 880, h: 620 },
        toa: [
          { tuX: 210, tuY: 250, tuR: -22 }, { tuX: 1700, tuY: 210, tuR: 17 },
          { tuX: 170, tuY: 760, tuR: 12 }, { tuX: 1740, tuY: 780, tuR: -14 },
          { tuX: 900, tuY: 110, tuR: 26 }, { tuX: 1020, tuY: 990, tuR: -8 },
        ],
        tick: { x: 1660, y: 500 },
        sao: [{ d: 124, x: 300, y: 520, s: 0.9 }, { d: 134, x: 1500, y: 950, s: 0.7 }],
      }
    : square
    ? {
        tu: { x: 130, y: 330, w: 820, h: 560 },
        toa: [
          { tuX: 180, tuY: 160, tuR: -22 }, { tuX: 900, tuY: 150, tuR: 17 },
          { tuX: 120, tuY: 620, tuR: 12 }, { tuX: 960, tuY: 600, tuR: -14 },
          { tuX: 540, tuY: 120, tuR: 26 }, { tuX: 560, tuY: 990, tuR: -8 },
        ],
        tick: { x: 880, y: 960 },
        sao: [{ d: 124, x: 140, y: 980, s: 0.9 }, { d: 134, x: 960, y: 200, s: 0.7 }],
      }
    : {
        tu: { x: 160, y: 700, w: 760, h: 560 },
        toa: [
          { tuX: 220, tuY: 430, tuR: -22 }, { tuX: 830, tuY: 380, tuR: 17 },
          { tuX: 180, tuY: 760, tuR: 12 }, { tuX: 880, tuY: 700, tuR: -14 },
          { tuX: 430, tuY: 300, tuR: 26 }, { tuX: 700, tuY: 1560, tuR: -8 },
        ],
        tick: { x: 830, y: 1600 },
        sao: [{ d: 124, x: 240, y: 1480, s: 0.9 }, { d: 134, x: 880, y: 640, s: 0.7 }],
      };

  const TU_X = P.tu.x, TU_Y = P.tu.y, TU_W = P.tu.w, TU_H = P.tu.h;
  const NGAN_H = TU_H / 3;

  // 6 to giay: bay lung tung KHAP khung -> vao 3 ngan (2 to/ngan)
  const TO = P.toa.map((t, i) => ({
    ...t, seed: 11 + i, ngan: Math.floor(i / 2) % 3, cot: i % 2, delay: 16 + i * 6,
  }));
  const VAO = 62; // moc bat dau bay vao tu

  return (
    <>
      <g>
        {/* TU HO SO - vat chinh, dat giua khung */}
        <Piece delay={54} seed={3} fromY={360} rotEnd={-1.5} bobAmp={3}>
          <g filter="url(#tornSmall)">
            <rect x={TU_X} y={TU_Y} width={TU_W} height={TU_H} rx="12" fill="url(#halftone)" stroke={INK} strokeWidth="8" />
            {[0, 1, 2].map((i) => (
              <g key={i}>
                <rect x={TU_X + 26} y={TU_Y + 22 + i * NGAN_H} width={TU_W - 52} height={NGAN_H - 30} rx="10"
                      fill={CREAM} stroke={INK} strokeWidth="6" />
                {/* tay nam ngan keo */}
                <rect x={TU_X + TU_W / 2 - 52} y={TU_Y + NGAN_H - 42 + i * NGAN_H} width="104" height="16" rx="8"
                      fill={INK} opacity="0.55" />
              </g>
            ))}
            {/* nhan mau canh tu */}
            <rect x={TU_X - 20} y={TU_Y + 40} width="20" height={TU_H - 80} rx="10" fill={ACCENT} />
          </g>
        </Piece>

        {/* 6 TO GIAY: lung tung -> xep vao ngan */}
        {TO.map((t, i) => {
          const cuoi = i === TO.length - 1;              // to cuoi con lo lung cho co chuyen dong
          const hien = spring({ frame: frame - t.delay, fps, config: { damping: 12, stiffness: 110 } });
          const vaoDelay = VAO + i * 8;
          const vao = cuoi
            ? spring({ frame: frame - (vaoDelay + 16), fps, config: { damping: 15, mass: 1.2, stiffness: 55 } })
            : spring({ frame: frame - vaoDelay, fps, config: { damping: 14, mass: 1.1, stiffness: 70 } });
          // dich den: nam gon trong ngan keo (2 to moi ngan, trai + phai)
          const denX = TU_X + TU_W * 0.28 + t.cot * TU_W * 0.44;
          const denY = TU_Y + NGAN_H * 0.5 + t.ngan * NGAN_H;
          const cx = interpolate(vao, [0, 1], [t.tuX, denX]);
          const cy = interpolate(vao, [0, 1], [t.tuY, denY]);
          const cr = interpolate(vao, [0, 1], [t.tuR, 0]);
          const sc = interpolate(vao, [0, 1], [1, 0.62]); // vao ngan van du to de nhin ro
          const lac = vao < 0.12 ? Math.sin(frame * 0.13 + i) * 6 : 0;
          const mo = hien * (vao > 0.9 ? 0.92 : 1);
          return (
            <g key={i} transform={`translate(${cx} ${cy + lac}) rotate(${cr}) scale(${sc})`} opacity={mo}
               style={{ filter: "url(#softshadow)" }}>
              <g filter="url(#tornSmall)">
                <rect x="-78" y="-100" width="156" height="200" rx="6" fill={CREAM} stroke={INK} strokeWidth="5" />
                <rect x="-52" y="-64" width="104" height="13" rx="6" fill={INK} opacity="0.72" />
                <rect x="-52" y="-32" width="78" height="13" rx="6" fill={INK} opacity="0.5" />
                <rect x="-52" y="0" width="94" height="13" rx="6" fill={INK} opacity="0.5" />
                <rect x="-52" y="32" width="60" height="13" rx="6" fill={INK} opacity="0.36" />
                <rect x="-78" y="-100" width="42" height="20" rx="4" fill={i % 2 ? ACCENT : POP} />
              </g>
            </g>
          );
        })}

        {/* dau tick chot: da ngan nap */}
        <g transform={`translate(${P.tick.x} ${P.tick.y}) scale(${tick.scale}) rotate(${tick.rot})`} opacity={tick.opacity}
           style={{ filter: "url(#softshadow)" }}>
          <circle r="82" fill={POP} />
          <circle r="82" fill="none" stroke={CREAM} strokeWidth="7" />
          <path d="M-34 2 L-8 30 L36 -26" stroke={CREAM} strokeWidth="17" fill="none"
                strokeLinecap="round" strokeLinejoin="round" />
        </g>
      </g>

      <g>
        <Sao diem={P.sao} />
      </g>
    </>
  );
};
