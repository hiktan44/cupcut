import type { EffectDefinition } from "@/effects/types";

export const FILM_GRAIN_SHADER = "film-grain";

export const filmGrainEffectDefinition: EffectDefinition = {
	type: "film-grain",
	name: "Film Grain",
	keywords: ["grain", "noise", "film", "vintage", "gürültü", "analog"],
	params: [
		{
			key: "intensity",
			label: "Intensity",
			type: "number",
			default: 20,
			min: 0,
			max: 100,
			step: 1,
		},
		{
			key: "size",
			label: "Grain Size",
			type: "number",
			default: 1,
			min: 1,
			max: 5,
			step: 0.1,
		},
	],
	renderer: {
		passes: [
			{
				shader: FILM_GRAIN_SHADER,
				uniforms: ({ effectParams }) => ({
					u_intensity: ((effectParams.intensity as number) ?? 20) / 100,
					u_size: (effectParams.size as number) ?? 1,
					u_time: Date.now() / 1000,
				}),
			},
		],
	},
};
