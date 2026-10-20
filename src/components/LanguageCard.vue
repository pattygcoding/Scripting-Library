<script setup lang="ts">
import type { LanguageGroup } from "../types";
import { exampleScripts, intercept, languageUrl, openLanguage } from "../store/session";

// One language folder, as a card on the home page - the "different options" the site
// opens on.  Its accent is the language's own brand colour (from the generator), and
// it names a few of the scripts inside so the card is not just a number.
const props = defineProps<{ group: LanguageGroup }>();

const examples = exampleScripts(props.group, 4);

function onClick(event: MouseEvent): void {
    intercept(event, () => openLanguage(props.group.slug));
}
</script>

<template>
    <a :href="languageUrl(group.slug)" @click="onClick"
       class="group relative overflow-hidden rounded-xl bg-ink-900 border border-line/5 p-5 transition hover:border-accent/30 hover:bg-ink-850 flex flex-col">
        <!-- The language's accent, as a bar down the card's edge. -->
        <span class="absolute inset-y-0 left-0 w-1" :style="{ backgroundColor: group.color }" aria-hidden="true"></span>
        <div class="flex items-start justify-between gap-3 pl-2">
            <div class="min-w-0">
                <h3 class="text-lg font-semibold tracking-tight text-fg-strong truncate group-hover:text-accent transition">{{ group.name }}</h3>
                <p class="micro mt-1 text-fg-dim">{{ group.count }} script{{ group.count === 1 ? "" : "s" }}</p>
            </div>
            <span class="lang-tag shrink-0" :title="group.name + ' scripts'">{{ group.extension }}</span>
        </div>
        <p class="mt-3 pl-2 text-sm leading-relaxed text-fg-soft">{{ group.description }}</p>
        <ul v-if="examples.length" class="mt-4 pl-2 space-y-1">
            <li v-for="script in examples" :key="script.id" class="text-xs text-fg-dim truncate">
                {{ script.name }}
            </li>
            <li v-if="group.count > examples.length" class="text-xs text-fg-dim">
                and {{ group.count - examples.length }} more
            </li>
        </ul>
        <p class="mt-4 pl-2 text-xs font-medium text-accent/80 group-hover:text-accent transition">
            Browse {{ group.name }} scripts &rarr;
        </p>
    </a>
</template>