import React from "react";
import { Composition } from "remotion";
import { Collage } from "./Collage";

// Do dai / fps / khung hinh / mau: KHONG hard-code.
// Skill chinh ra lenh -> lam_broll.py truyen vao qua --props.
// calculateMetadata ghi de metadata theo props moi lan chay.
export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="Collage"
      component={Collage}
      durationInFrames={150}
      fps={30}
      width={1080}
      height={1920}
      defaultProps={{
        scene: "quay-cat-xuat-ban",
        bg: "#1b7d70",
        accent: "#e8b23a",
        pop: "#e0503a",
      }}
      calculateMetadata={({ props }) => {
        const p = props as any;
        return {
          durationInFrames: p.durationInFrames ?? 150,
          fps: p.fps ?? 30,
          width: p.width ?? 1080,
          height: p.height ?? 1920,
        };
      }}
    />
  );
};
