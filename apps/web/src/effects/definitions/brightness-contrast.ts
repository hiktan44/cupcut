import type { EffectDefinition } from "@/effects/types";

export const BRIGHTNESS_CONTRAST_SHADER = "brightness-contrast";

export const brightnessContrastEffectDefinition: EffectDefinition = {
	type: "brightness-contrast",
	name: "Brightness & Contrast",
	keywords: ["brightness", "contrast", "exposure", "parlaklık", "kontrast"],
	params: [
		{
			key: "brightness",
			label: "Brightness",
			type: "number",
			default: 0,
			min: -100,
			max: 100,
			step: 1,
		},
		{
			key: "contrast",
			label: "Contrast",
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
				shader: BRIGHTNESS_CONTRAST_SHADER,
				uniforms: ({ effectParams }) => ({
					u_brightness: ((effectParams.brightness as number) ?? 0) / 100,
					u_contrast: ((effectParams.contrast as number) ?? 0) / 100,
				}),
			},
		],
	},
};
