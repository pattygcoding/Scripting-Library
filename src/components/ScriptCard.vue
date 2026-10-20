<script setup lang="ts">
import type { Item } from "../types";
import { intercept, selectScript, stateUrl } from "../store/session";

// One script, as a card in a language page's grid (and in the home page's search
// results).  The whole card is a real link to the script's own address, so it can be
// copied or opened in a new tab; a plain left click stays in the page.
const props = defineProps<{ item: Item }>();

function onClick(event: MouseEvent): void {
    intercept(event, () => selectScript(props.item.id));
}
</script>

<template>
    <a :href="stateUrl(item.id, 'code')" @click="onClick"
       class="group block rounded-lg bg-ink-900 border border-line/5 p-4 transition hover:border-accent/30 hover:bg-ink-850">
        <div class="flex items-start justify-between gap-3">
            <h3 class="text-sm font-semibold text-fg-strong truncate group-hover:text-accent transition">{{ item.name }}</h3>
            <span class="lang-tag shrink-0" :title="item.file">{{ item.extension }}</span>
        </div>
        <!-- The first sentence of the script's own README, so a card says what the
             script does rather than only what it is called. -->
        <p v-if="item.summary" class="clamp-2 mt-2 text-xs leading-relaxed text-fg-muted">{{ item.summary }}</p>
        <p class="mt-3 text-[11px] font-mono text-fg-dim truncate">{{ item.folder }}</p>
    </a>
</template>