<script setup lang="ts">
import { heroLine, languageCards, searchPlaceholder, searchResults, setQuery, state } from "../store/session";
import LanguageCard from "./LanguageCard.vue";
import ScriptCard from "./ScriptCard.vue";

// The home page: the six language folders as cards, and a search box that searches
// every script in the library at once.  Typing takes the page over with the matching
// scripts, so the same screen answers "what is in here" and "where is this script".
</script>

<template>
    <main class="flex-1 min-h-0 overflow-y-auto">
        <div class="mx-auto w-full max-w-6xl px-3 sm:px-6 py-8 sm:py-12">
            <p class="micro text-fg-dim">Scripting Library</p>
            <h1 class="mt-2 text-3xl sm:text-4xl font-semibold tracking-tight text-fg-strong">
                Six languages, <span class="text-accent">one library</span>.
            </h1>
            <p class="mt-3 max-w-3xl text-sm sm:text-base leading-relaxed text-fg-soft">
                Every script in the library, with its source and the documentation that sits
                beside it. Pick a language to browse what it holds, or search the collection.
            </p>
            <p class="micro mt-4 text-accent/80">{{ heroLine }}</p>

            <div class="mt-6">
                <input type="search" :placeholder="searchPlaceholder" :value="state.query"
                       aria-label="Search every script"
                       @input="setQuery(($event.target as HTMLInputElement).value)"
                       class="w-full sm:max-w-md bg-ink-900 border border-line/10 rounded-md px-3 py-2.5 text-sm text-fg
                              placeholder:text-hint focus:outline-none focus:border-accent/60 focus:ring-1 focus:ring-accent/20 transition" />
            </div>

            <!-- The matches, once there is a search to answer. -->
            <template v-if="searchResults.length">
                <div class="mt-8 flex items-baseline justify-between gap-3">
                    <h2 class="text-sm font-semibold text-fg-strong">
                        {{ searchResults.length }} matching script{{ searchResults.length === 1 ? "" : "s" }}
                    </h2>
                    <span class="micro text-fg-dim">across every language</span>
                </div>
                <div class="mt-3 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
                    <ScriptCard v-for="item in searchResults" :key="item.id" :item="item" />
                </div>
            </template>
            <p v-else-if="state.query.trim()" class="mt-8 text-sm text-fg-muted">No scripts match that search.</p>

            <!-- Otherwise: the options themselves. -->
            <template v-else>
                <div class="mt-8 flex items-baseline justify-between gap-3">
                    <h2 class="text-sm font-semibold text-fg-strong">Languages</h2>
                    <span class="micro text-fg-dim">choose one to browse</span>
                </div>
                <div class="mt-3 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    <LanguageCard v-for="group in languageCards" :key="group.slug" :group="group" />
                </div>
            </template>
        </div>
    </main>
</template>