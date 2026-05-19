import type { EffectDefinition } from "@/effects/types";

export const SHARPEN_SHADER = "sharpen";

export const sharpenEffectDefinition: EffectDefinition = {
	type: "sharpen",
	name: "Sharpen",
	keywords: ["sharpen", "sharp", "detail", "keskinlik", "netlik"],
	params: [
		{
			key: "intensity",
			label: "Intensity",
			type: "number",
			default: 30,
			min: 0,
			max: 100,
			step: 1,
		},
	],
	renderer: {
		passes: [
			{
				shader: SHARPEN_SHADER,
				uniforms: ({ effectParams }) => ({
					u_intensity: ((effectParams.intensity as number) ?? 30) / 100,
				}),
			},
		],
	},
};
