import { effectsRegistry } from "../registry";
import { blurEffectDefinition } from "./blur";
import { brightnessContrastEffectDefinition } from "./brightness-contrast";
import { hslEffectDefinition } from "./hsl";
import { vignetteEffectDefinition } from "./vignette";
import { sharpenEffectDefinition } from "./sharpen";
import { filmGrainEffectDefinition } from "./film-grain";

const defaultEffects = [
	blurEffectDefinition,
	brightnessContrastEffectDefinition,
	hslEffectDefinition,
	vignetteEffectDefinition,
	sharpenEffectDefinition,
	filmGrainEffectDefinition,
];

export function registerDefaultEffects(): void {
	for (const definition of defaultEffects) {
		if (effectsRegistry.has(definition.type)) {
			continue;
		}
		effectsRegistry.register({
			key: definition.type,
			definition,
		});
	}
}
