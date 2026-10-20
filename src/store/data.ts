import type { DashboardData, Item, LanguageGroup, TabId } from "../types";

// Everything the dashboard displays, read straight from the generated payload.
// These helpers are pure lookups over `DATA` - the reactive selection on top of
// them lives in `session.ts`.
export const DATA: DashboardData | undefined = window.SCRIPTING_LIBRARY_DATA;

// A checkout that has not run the generator yet still boots and shows the empty
// state (which says how to generate the data) instead of throwing.
export const hasData: boolean = !!DATA && Array.isArray(DATA.scripts) && DATA.scripts.length > 0;

// The script the showcase falls back to when the address names a language but no
// script (`/bash` alone): that language's first script.  "Clear Git" ships in all six
// languages, so it leads the library's first folder; a fork without it falls back to
// the first script present.
export const DEFAULT_SCRIPT_ID = "bash/clear-git";

// The last-resort repository, for the one place a link cannot read `meta`: a
// checkout that has not generated the showcase data yet.  The generator writes the
// real one (git remote, else GITHUB_REPOSITORY, else this same default).
const DEFAULT_REPOSITORY = "https://github.com/pattygcoding/Scripting-Library";

export function scripts(): Item[] {
    return DATA?.scripts ?? [];
}

export function languageGroups(): LanguageGroup[] {
    return DATA?.languages ?? [];
}

export function languageBySlug(slug: string | null | undefined): LanguageGroup | undefined {
    if (!slug) {
        return undefined;
    }
    return languageGroups().find((group) => group.slug === slug);
}

export function knownLanguage(slug: string | null | undefined): boolean {
    return !!languageBySlug(slug);
}

// The scripts in one language folder, in the order the generator listed them.
export function scriptsForLanguage(slug: string | null | undefined): Item[] {
    if (!slug) {
        return [];
    }
    return scripts().filter((item) => item.languageSlug === slug);
}

export function itemById(id: string | null | undefined): Item | undefined {
    if (!id) {
        return undefined;
    }
    return scripts().find((item) => item.id === id);
}

export function knownScript(id: string | null | undefined): boolean {
    return !!itemById(id);
}

// The flat address an older link used (`bash-clear-git`) resolved to the script it
// named, so addresses from before the `/language/script` scheme keep working.
export function itemByLegacyId(flat: string | null | undefined): Item | undefined {
    if (!flat) {
        return undefined;
    }
    return scripts().find((item) => item.languageSlug + "-" + item.slug === flat);
}

// A language's first script, which is what `/bash` opens when it names no script.
export function firstScriptIdForLanguage(slug: string | null | undefined): string | null {
    return scriptsForLanguage(slug)[0]?.id ?? null;
}

export function defaultScriptId(): string | null {
    return itemById(DEFAULT_SCRIPT_ID)?.id ?? scripts()[0]?.id ?? null;
}

// Whether a script can show a tab.  Every script has source; the documentation tab
// needs the README.md the generator read out of its folder, so the four folders that
// have none simply drop the tab.
export function tabAvailableFor(item: Item | undefined, tab: TabId): boolean {
    if (tab === "docs") {
        return !!item?.docs;
    }
    return true;
}

// The tab a script opens on.
export function defaultTabFor(): TabId {
    return "code";
}

// The folder a script lives in, used for its GitHub link.  The generator records it
// explicitly, so the header and the link never have to re-derive it from the path.
export function repoFolder(item: Item): string {
    return item.folder || (item.file || "").replace(/\/[^/]*$/, "");
}

// `<repository>/tree/<branch>/<folder>`.  Folder names here are real script names
// (`Clear Git`, `Update GIt`, `Compare Columns`), so every path segment is
// URL-encoded - a raw `#` would otherwise be read as a fragment and break the link.
export function repoTreeUrl(folder: string): string {
    const repository = DATA?.meta?.repository;
    if (!repository || !folder) {
        return "";
    }
    const path = folder.split("/").map(encodeURIComponent).join("/");
    return repository + "/tree/" + (DATA?.meta?.branch || "main") + "/" + path;
}

export function repoUrlFor(item: Item): string {
    return repoTreeUrl(repoFolder(item));
}

// A language's own folder on GitHub, behind its page's link.
export function repoUrlForLanguage(group: LanguageGroup | undefined): string {
    return repoTreeUrl(group?.folder ?? "");
}

// The repository root itself, behind the banner's GitHub mark - the same generated
// `meta.repository` the per-folder links are built from, so a fork marks its own
// project.
export function repoHomeUrl(): string {
    return DATA?.meta?.repository || DEFAULT_REPOSITORY;
}

// The line-number column beside the code: one number per line, trimmed of the
// trailing blank lines a file ends with.
export function lineNumbersFor(text: string): string {
    const normalized = text.replace(/\n+$/, "");
    const count = normalized.length ? normalized.split("\n").length : 1;
    const numbers: number[] = [];
    for (let line = 1; line <= count; line += 1) {
        numbers.push(line);
    }
    return numbers.join("\n");
}
