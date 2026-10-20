<script setup lang="ts">
import { nextTick, ref, watch } from "vue";
import { listMessage, selectScript, state, stateUrl, visibleItems } from "../store/session";

// The list is real links, so every script can be copied, bookmarked or opened in a
// new tab; a plain left click stays in the page.
function onSelect(event: MouseEvent, id: string): void {
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
        return;
    }
    event.preventDefault();
    selectScript(id);
}

// A deep link (/python-count-files) has to reveal its row, not leave the list at the
// top with the highlight far below the fold.  `nearest` scrolls only the list, and
// only when the row is actually out of view.
const nav = ref<HTMLElement | null>(null);
watch(
    () => state.scriptId,
    async () => {
        await nextTick();
        nav.value?.querySelector<HTMLElement>('[aria-current="page"]')?.scrollIntoView({ block: "nearest" });
    },
    { immediate: true },
);
</script>

<template>
    <nav ref="nav" class="overflow-y-auto flex-1 min-h-0 p-2 space-y-1">
        <p v-if="visibleItems.length === 0" class="micro text-fg-dim px-3 py-2">{{ listMessage }}</p>
        <a v-else v-for="item in visibleItems" :key="item.id"
           :href="stateUrl(item.id, state.tab)"
           :aria-current="item.id === state.scriptId ? 'page' : undefined"
           :class="['w-full text-left px-3 py-2.5 rounded-md text-sm font-medium transition flex items-center justify-between gap-2',
                    item.id === state.scriptId
                        ? 'bg-accent/10 text-accent border border-accent/30'
                        : 'text-fg-soft hover:bg-line/5 border border-transparent']"
           @click="onSelect($event, item.id)">
            <span class="truncate">{{ item.name }}</span>
            <!-- Badges: the language folder and the blue file-extension tag. -->
            <span class="flex items-center gap-1 shrink-0">
                <span class="micro px-1.5 py-0.5 rounded border border-line/10 text-fg-dim">{{ item.language || "Other" }}</span>
                <span class="lang-tag" :title="item.file">{{ item.extension }}</span>
            </span>
        </a>
    </nav>
</template>
