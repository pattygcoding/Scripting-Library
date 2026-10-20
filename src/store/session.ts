import { computed, reactive } from "vue";
import type { Item, LanguageGroup, TabId, ViewKind } from "../types";
import * as data from "./data";

// ---- The address ----------------------------------------------------------------
// Three screens, each with its own address:
//
//   /                       the home page - the six language folders as cards
//   /powershell             one language's scripts, as cards
//   /powershell/update-git  one script, with a tolerated /docs tab segment
//
// The dashboard is a static bundle, so the path is resolved client-side with the
// History API.  A document with a null origin (file://) refuses path writes, so the
// query-string shape (?lang=, ?script=) is used there instead - and those are the
// params the deployed site's 404.html shim fills in.  Both shapes are readable, and
// the flat addresses of the first version (`/bash-clear-git`) still resolve.
//
// The directory the site is served from is whatever is left above the route: the tab
// and the one or two segments the data knows are stripped off the end, which is what
// makes one build work both at the custom domain's root (nothing left to strip) and
// under a `<user>.github.io/<repo>/` path - where "Scripting-Library" is not a
// language, so the strip stops above it.  Every link and history write uses this.
const APP_DIR = (function deploymentDir(): string {
    const parts = window.location.pathname.split("/").filter(Boolean);
    if (parts.length > 0 && /^index\.html?$/i.test(parts[parts.length - 1])) {
        parts.pop();
    }
    if (parts.length > 0 && /^(code|docs)$/i.test(parts[parts.length - 1])) {
        parts.pop();
    }
    if (parts.length > 1) {
        const language = parts[parts.length - 2].toLowerCase();
        const id = language + "/" + parts[parts.length - 1].toLowerCase();
        if (data.knownLanguage(language) && data.knownScript(id)) {
            parts.pop();
            parts.pop();
        }
    }
    if (parts.length > 0) {
        const last = parts[parts.length - 1].toLowerCase();
        if (data.knownLanguage(last) || data.itemByLegacyId(last)) {
            parts.pop();
        }
    }
    return parts.length > 0 ? "/" + parts.join("/") + "/" : "/";
})();

let applyingHistory = false;

// Can this document write a path?  Probing once here, rather than discovering it
// when the first write fails, keeps the banner's and the cards' hrefs in the right
// shape from the very first render; the temporary URL is restored in the same tick,
// before anything can observe it.
let canWritePath = (function probePathWrites(): boolean {
    const original = window.location.href;
    try {
        window.history.replaceState(window.history.state, "", APP_DIR + "__path-probe__");
    } catch {
        return false;
    }
    try {
        window.history.replaceState(window.history.state, "", original);
    } catch {
        // keep going: the probe already told us path writes are allowed
    }
    return true;
})();

interface LocationState {
    view: ViewKind;
    languageSlug: string | null;
    scriptId: string | null;
    tab: TabId;
    explicitTab: boolean;
}

// The segments the address names.  The 404 shim cannot know which leading segments
// are the deployment prefix, so it forwards the requested path in `?path=`; a real
// path is read straight off the bar.  Either way the route is found from the end, so
// no prefix ever has to be guessed at.
function addressSegments(params: URLSearchParams): string[] {
    const tail = params.get("path") ?? window.location.pathname;
    return tail
        .split("/")
        .filter((part) => part !== "")
        .map((part) => {
            try {
                return decodeURIComponent(part);
            } catch {
                return part;
            }
        });
}

// Which screen a run of segments names: the last two as `<language>/<script>`, the
// last one as a language, or - for a link from the first version of the site - as a
// flat `<language>-<script>` id.  Anything else is the home page.
function resolveRoute(segments: string[]): { view: ViewKind; languageSlug: string | null; scriptId: string | null } {
    const parts = segments.slice();
    if (parts.length > 0 && /^index\.html?$/i.test(parts[parts.length - 1])) {
        parts.pop();
    }
    if (parts.length > 1) {
        const language = parts[parts.length - 2].toLowerCase();
        const id = language + "/" + parts[parts.length - 1].toLowerCase();
        if (data.knownLanguage(language) && data.knownScript(id)) {
            return { view: "script", languageSlug: language, scriptId: id };
        }
    }
    if (parts.length > 0) {
        const last = parts[parts.length - 1].toLowerCase();
        if (data.knownLanguage(last)) {
            return { view: "language", languageSlug: last, scriptId: null };
        }
        const legacy = data.itemByLegacyId(last);
        if (legacy) {
            return { view: "script", languageSlug: legacy.languageSlug, scriptId: legacy.id };
        }
    }
    return { view: "home", languageSlug: null, scriptId: null };
}

// What the current address asks for, in either shape.  `/powershell/update-git/docs`
// names the tab on the path, `?tab=docs` names it in a query - both shapes the 404
// shim forwards.
function locationState(): LocationState {
    const params = new URLSearchParams(window.location.search || "");
    const segments = addressSegments(params);
    const pathTab = segments.length > 0 && /^(code|docs)$/i.test(segments[segments.length - 1]);
    const rawTab = pathTab
        ? segments[segments.length - 1].toLowerCase()
        : (params.get("tab") || "").toLowerCase();
    if (pathTab) {
        segments.pop();
    }
    const tab: TabId = rawTab === "docs" ? "docs" : "code";
    const explicitTab = pathTab || params.has("tab");

    const route = resolveRoute(segments);
    if (route.view !== "home") {
        return { view: route.view, languageSlug: route.languageSlug, scriptId: route.scriptId, tab, explicitTab };
    }
    // The query fallbacks: a document that cannot write a path, and a link that
    // carried only a param.
    const scriptParam = (params.get("script") || "").trim();
    const fromScript = scriptParam ? data.itemById(scriptParam) ?? data.itemByLegacyId(scriptParam) : undefined;
    if (fromScript) {
        return { view: "script", languageSlug: fromScript.languageSlug, scriptId: fromScript.id, tab, explicitTab };
    }
    const langParam = (params.get("lang") || "").trim().toLowerCase();
    if (data.knownLanguage(langParam)) {
        return { view: "language", languageSlug: langParam, scriptId: null, tab, explicitTab };
    }
    return { view: "home", languageSlug: null, scriptId: null, tab, explicitTab };
}

// The home page's address: the deployment root itself.
export function homeUrl(): string {
    return canWritePath ? APP_DIR : queryUrl({});
}

// `/powershell`, or `?lang=powershell` where a path cannot be written.
export function languageUrl(slug: string): string {
    return canWritePath ? APP_DIR + slug : queryUrl({ lang: slug });
}

// `/powershell/update-git`, with `?tab=docs` only when the tab is not the one the
// script opens on and the script can show it.  Used for the cards' and the breadcrumb's
// real links, so a copied or middle-clicked link carries the script and the tab along.
export function stateUrl(scriptId: string, tab: TabId): string {
    if (!data.tabAvailableFor(data.itemById(scriptId), tab)) {
        tab = "code";
    }
    if (canWritePath) {
        const query = tab === data.defaultTabFor() ? "" : "?tab=" + tab;
        return APP_DIR + scriptId + query;
    }
    return queryUrl(tab === data.defaultTabFor() ? { script: scriptId } : { script: scriptId, tab });
}

// The query-string shape: what a document that refuses path writes uses, and what the
// 404 shim hands over.  Route params from the previous screen are cleared first, so
// the address never carries two answers at once.
function queryUrl(values: Record<string, string>): string {
    const params = new URLSearchParams(window.location.search || "");
    for (const key of ["path", "script", "lang", "tab"]) {
        params.delete(key);
    }
    for (const [key, value] of Object.entries(values)) {
        params.set(key, value);
    }
    const query = params.toString();
    return window.location.pathname + (query ? "?" + query : "");
}

function syncUrl(mode: "push" | "replace"): void {
    if (applyingHistory) {
        return;
    }
    let url: string;
    if (state.view === "script" && state.scriptId) {
        url = stateUrl(state.scriptId, state.tab);
    } else if (state.view === "language" && state.languageSlug) {
        url = languageUrl(state.languageSlug);
    } else {
        url = homeUrl();
    }
    try {
        window.history[mode === "push" ? "pushState" : "replaceState"](null, "", url);
    } catch {
        // Belt and braces: fall back to the query shape such a document allows.
        if (canWritePath) {
            canWritePath = false;
            syncUrl(mode);
        }
    }
}

// Back/forward: rebuild the view from the address without writing it again.
function applyLocation(): void {
    const target = locationState();
    applyingHistory = true;
    state.view = target.view;
    state.languageSlug = target.languageSlug;
    state.scriptId = target.scriptId;
    state.tab = target.explicitTab ? target.tab : data.defaultTabFor();
    if (!data.tabAvailableFor(currentItem.value, state.tab)) {
        state.tab = "code";
    }
    applyingHistory = false;
}

// ---- Selection ------------------------------------------------------------------
export const state = reactive({
    /** Which screen is on display. */
    view: "home" as ViewKind,
    /** The language whose page is open, on the language and script screens. */
    languageSlug: null as string | null,
    /** The script whose page is open. */
    scriptId: null as string | null,
    tab: "code" as TabId,
    /** The page's search box. */
    query: "",
});

export const currentItem = computed<Item | undefined>(() => data.itemById(state.scriptId));

// The language the current screen belongs to: the script's own row on a script page,
// the named folder on a language page, and nothing at all on the home page.
export const currentLanguage = computed<LanguageGroup | undefined>(() =>
    data.languageBySlug(state.languageSlug ?? currentItem.value?.languageSlug ?? null),
);

// The home page's cards, one per language folder, in the repository's own order.
export const languageCards = computed<LanguageGroup[]>(() => data.languageGroups());

// The first few scripts of one folder, so a home page card can name what is inside
// rather than only how many there are.
export function exampleScripts(group: LanguageGroup, limit: number): Item[] {
    return data.scriptsForLanguage(group.slug).slice(0, limit);
}

function matchesQuery(item: Item, query: string): boolean {
    const haystack = [item.name, item.id, item.language, item.file, item.summary ?? ""].join(" ").toLowerCase();
    return haystack.includes(query);
}

// The language page lists just its own folder's scripts, filtered by that page's
// search box.
export const visibleScripts = computed<Item[]>(() => {
    const scoped = data.scriptsForLanguage(state.languageSlug);
    const query = state.query.trim().toLowerCase();
    return query === "" ? scoped : scoped.filter((item) => matchesQuery(item, query));
});

// The home page's search box looks across every language, and only takes over the
// page once there is something to search for.
export const searchResults = computed<Item[]>(() => {
    const query = state.query.trim().toLowerCase();
    return query === "" ? [] : data.scripts().filter((item) => matchesQuery(item, query));
});

// The scripts of the language the current screen belongs to - the "more in this
// language" strip under a script.
export const scriptsInLanguage = computed<Item[]>(() => data.scriptsForLanguage(currentLanguage.value?.slug));

export const searchPlaceholder = "Search scripts...";

export const listMessage = computed<string>(() => {
    if (data.scripts().length === 0) {
        return "No scripts yet.";
    }
    return "No scripts match your search.";
});

export const metaLine = computed<string>(() => {
    const meta = data.DATA?.meta;
    const scriptCount = meta?.scriptCount || data.scripts().length;
    const languageCount = meta?.languageCount || data.languageGroups().length;
    const counts = scriptCount + " script" + (scriptCount === 1 ? "" : "s") +
        " \u00b7 " + languageCount + " language" + (languageCount === 1 ? "" : "s");
    return counts + " \u00b7 updated " + (meta?.updated || "n/a");
});

// The home page's headline figure: what the library holds, and how much of it
// carries the documentation every script folder is supposed to ship.
export const heroLine = computed<string>(() => {
    const meta = data.DATA?.meta;
    const scriptCount = meta?.scriptCount || data.scripts().length;
    const languageCount = meta?.languageCount || data.languageGroups().length;
    const documented = meta?.documentedCount ?? data.scripts().filter((item) => item.docs).length;
    return scriptCount + " scripts across " + languageCount + " languages \u00b7 " +
        documented + " with documentation";
});

// ---- Links ----------------------------------------------------------------------
export const repoUrl = computed<string>(() => (currentItem.value ? data.repoUrlFor(currentItem.value) : ""));

// The language's own folder on GitHub, behind the language page's link.
export const repoLanguageUrl = computed<string>(() => data.repoUrlForLanguage(currentLanguage.value));

// The repository root, behind the banner's GitHub mark: a real link rather than a
// per-folder one, so the whole project is one click away from every screen.
export const repoHomeUrl = computed<string>(() => data.repoHomeUrl());

export const repoFolderName = computed<string>(() => (currentItem.value ? data.repoFolder(currentItem.value) : ""));

// ---- Documentation --------------------------------------------------------------
// The README.md lives in the script's own folder, so unlike the shared console
// captures of the other showcases this tab is per script: it exists only when the
// generator found a README beside the source.
export const showDocsTab = computed<boolean>(() => data.tabAvailableFor(currentItem.value, "docs"));

export const docsText = computed<string>(() => currentItem.value?.docs ?? "");

// The language folder's own README, shown as that page's overview of the folder.
export const languageDocs = computed<string>(() => currentLanguage.value?.docs ?? "");

// ---- Actions --------------------------------------------------------------------
export function setQuery(value: string): void {
    state.query = value;
}

// A card, a banner link or a breadcrumb is a real <a href>, so it can be copied,
// bookmarked or opened in a new tab; a plain left click stays in the page and moves
// the view instead of reloading the document.
export function intercept(event: MouseEvent, navigate: () => void): void {
    if (event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
        return;
    }
    event.preventDefault();
    navigate();
}

// The home page: the language grid.
export function goHome(): void {
    state.view = "home";
    state.languageSlug = null;
    state.scriptId = null;
    state.query = "";
    syncUrl("push");
}

// One language's page: its scripts as cards.  Arriving from the home page clears the
// search, because the search box belonged to the grid that was just left.
export function openLanguage(slug: string): void {
    if (!data.knownLanguage(slug)) {
        return;
    }
    state.view = "language";
    state.languageSlug = slug;
    state.scriptId = null;
    state.query = "";
    syncUrl("push");
}

// One script's page.  A tab the script cannot show would leave an empty panel, so it
// falls back to the source before the address is written.
export function selectScript(id: string): void {
    const item = data.itemById(id);
    if (!item) {
        return;
    }
    state.view = "script";
    state.languageSlug = item.languageSlug;
    state.scriptId = item.id;
    state.query = "";
    if (!data.tabAvailableFor(item, state.tab)) {
        state.tab = "code";
    }
    syncUrl("push");
}

export function switchTab(tab: TabId): void {
    if (!data.tabAvailableFor(currentItem.value, tab)) {
        tab = "code";
    }
    const changed = state.tab !== tab;
    state.tab = tab;
    if (changed) {
        syncUrl("push");
    }
}

// Mirror the address into the view; the address is only written at the end (the
// screen taken from the URL must not add a history entry).
export function initSession(): void {
    if (!data.hasData) {
        return;
    }
    const target = locationState();
    state.view = target.view;
    state.languageSlug = target.languageSlug;
    state.scriptId = target.scriptId;
    state.tab = target.explicitTab ? target.tab : data.defaultTabFor();
    if (!data.tabAvailableFor(currentItem.value, state.tab)) {
        state.tab = "code";
    }
    syncUrl("replace");   // canonical address for what is on screen

    window.addEventListener("popstate", applyLocation);
}
