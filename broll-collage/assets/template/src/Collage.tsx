// ============================================================
// KHUNG NGOAI: nen + hat giay + chon canh theo prop `scene`.
// Them canh moi: tao file trong src/canh/, dang ky vao DS_CANH ben duoi,
// va them tu khoa trong scripts/lam_broll.py (BANG_CANH).
// ============================================================
import React from "react";
import { AbsoluteFill, useVideoConfig } from "remotion";
import { Defs, CREAM, ACCENT, POP, useQFrame } from "./chatlieu";
import { QuayCatXuatBan } from "./canh/QuayCatXuatBan";
import { ThoiGianTroi } from "./canh/ThoiGianTroi";
import { HonLoanNganNap } from "./canh/HonLoanNganNap";
import { TangTruong } from "./canh/TangTruong";
import { MayLamThay } from "./canh/MayLamThay";

export const DS_CANH: Record<string, React.FC<{ wide: boolean; square: boolean }>> = {
  "quay-cat-xuat-ban": QuayCatXuatBan,
  "thoi-gian-troi": ThoiGianTroi,
  "hon-loan-ngan-nap": HonLoanNganNap,
  "tang-truong": TangTruong,
  "may-lam-thay": MayLamThay,
};

type Props = { bg?: string; accent?: string; pop?: string; scene?: string };

export const Collage: React.FC<Props> = ({
  bg = "#1b7d70",
  accent = "#e8b23a",
  pop = "#e0503a",
  scene = "quay-cat-xuat-ban",
}) => {
  const { width: W, height: H } = useVideoConfig();
  const frame = useQFrame();

  // Bo cuc thich ung: khung ngang/vuong KHONG cat xen (cat la mat vat chinh),
  // moi canh tu xep lai cac cum theo huong khung.
  const wide = W > H * 1.15;
  const square = !wide && W > H * 0.9;

  const Canh = DS_CANH[scene] ?? QuayCatXuatBan;
  const decoT = wide ? "translate(170 60) scale(0.58)" : square ? "translate(40 20) scale(0.72)" : "";

  return (
    <AbsoluteFill
      style={{ backgroundColor: bg, "--bg": bg, "--accent": accent, "--pop": pop } as React.CSSProperties}
    >
      <svg width={W} height={H} viewBox={`0 0 ${W} ${H}`}>
        <Defs />

        {/* nen phu kin moi ti le khung */}
        <rect width={W} height={H} fill={bg} />
        <rect width={W} height={H} fill="#000000" opacity="0.16" />
        <rect width={W} height={H} fill="url(#leak)" />

        {/* vun giay rai goc cho giau chat lieu */}
        <g opacity="0.25" filter="url(#tornSmall)" transform={decoT}>
          <rect x="60" y="180" width="90" height="60" fill={CREAM} transform="rotate(-18 105 210)" />
          <rect x="930" y="1700" width="110" height="70" fill={ACCENT} transform="rotate(12 985 1735)" />
          <rect x="80" y="1620" width="70" height="90" fill={POP} transform="rotate(24 115 1665)" />
        </g>
        <rect width={W} height={H} fill="url(#vig)" />

        {/* ==== CANH ==== */}
        <Canh wide={wide} square={square} />

        {/* hat giay toan khung (luon o tren cung) */}
        <rect width={W} height={H} filter="url(#grain)" opacity="0.55" />
      </svg>
    </AbsoluteFill>
  );
};
