import type { EffectDefinition } from "@/effects/types";

export const VIGNETTE_SHADER = "vignette";

export const vignetteEffectDefinition: EffectDefinition = {
	type: "vignette",
	name: "Vignette",
	keywords: ["vignette", "dark edges", "cinematic", "film", "kenarlık"],
	params: [
		{
			key: "intensity",
			label: "Intensity",
			type: "number",
			default: 50,
			min: 0,
			max: 100,
			step: 1,
		},
		{
			key: "softness",
			label: "Softness",
			type: "number",
			default: 50,
			min: 0,
			max: 100,
			step: 1,
		},
	],
	renderer: {
		passes: [
			{
				shader: VIGNETTE_SHADER,
				uniforms: ({ effectParams }) => ({
					u_intensity: ((effectParams.intensity as number) ?? 50) / 100,
					u_softness: ((effectParams.softness as number) ?? 50) / 100,
				}),
			},
		],
	},
};
