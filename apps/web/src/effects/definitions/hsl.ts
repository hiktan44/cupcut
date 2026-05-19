import type { EffectDefinition } from "@/effects/types";

export const HSL_SHADER = "hsl-adjust";

export const hslEffectDefinition: EffectDefinition = {
	type: "hsl",
	name: "Color (HSL)",
	keywords: ["hue", "saturation", "lightness", "color", "renk", "doygunluk"],
	params: [
		{
			key: "hue",
			label: "Hue",
			type: "number",
			default: 0,
			min: -180,
			max: 180,
			step: 1,
		},
		{
			key: "saturation",
			label: "Saturation",
			type: "number",
			default: 0,
			min: -100,
			max: 100,
			step: 1,
		},
		{
			key: "lightness",
			label: "Lightness",
			type: "number",
			default: 0,
			min: -100,
			max: 100,
			step: 1,
		},
	],
	renderer: {
		passes: [
			{
				shader: HSL_SHADER,
				uniforms: ({ effectParams }) => ({
					u_hue: ((effectParams.hue as number) ?? 0) / 180,
					u_saturation: ((effectParams.saturation as number) ?? 0) / 100,
					u_lightness: ((effectParams.lightness as number) ?? 0) / 100,
				}),
			},
		],
	},
};
