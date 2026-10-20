// The shape of `public/scripts-data.js`, which tools/generate-data.mjs writes from
// the real repository.  Every script has the same shape, so the cards, the header and
// the code panel stay unaware of which language they show.

export type TabId = "code" | "docs";

/** Which screen the address names: the language grid, one language, or one script. */
export type ViewKind = "home" | "language" | "script";

export interface Item {
    /** The script's address path, e.g. `powershell/update-git`. */
    id: string;
    /** The last address segment alone, e.g. `update-git`. */
    slug: string;
    /** The script's folder name, e.g. `Update Git`. */
    name: string;
    /** The language row this script belongs to, e.g. `PowerShell`. */
    language: string;
    /** That language's address segment, e.g. `powershell`. */
    languageSlug: string;
    /** The Prism grammar class, e.g. `language-powershell`. */
    prism: string;
    /** The source path shown above the code and linked on GitHub. */
    file: string;
    /** The script's folder - what the GitHub link points at. */
    folder: string;
    /** The file-extension tag shown on a card, e.g. `.ps1`. */
    extension: string;
    /** The first sentence of the folder's README, for the card.  Absent when the
        folder ships no README. */
    summary?: string;
    /** An optional sentence shown above the code (a folder that ships more than
        one file, e.g. the spreadsheet scripts' .vba/.gs/.ts trio). */
    note?: string;
    /** The folder's README.md, shown on the Documentation tab.  Absent for the
        few folders that have none, which is what hides the tab. */
    docs?: string;
    code: string;
}

/** One language row: a folder of scripts and what identifies it. */
export interface LanguageGroup {
    name: string;
    /** The address segment its page lives at, e.g. `powershell`. */
    slug: string;
    /** The file-extension tag shown on the card, e.g. `.ps1`. */
    extension: string;
    prism: string;
    /** A legible accent derived from the language's brand colour. */
    color: string;
    /** The one-line description the home page card shows. */
    description: string;
    /** The folder the language lives in, for its GitHub link. */
    folder: string;
    /** The folder's own README.md, shown as the language page's overview. */
    docs?: string;
    /** How many scripts the folder holds. */
    count: number;
}

export interface DataMeta {
    updated: string;
    languageCount: number;
    scriptCount: number;
    /** How many scripts ship a README.md. */
    documentedCount: number;
    repository: string;
    branch: string;
}

export interface DashboardData {
    meta: DataMeta;
    /** The language folders, in the order the repository lists them. */
    languages: LanguageGroup[];
    scripts: Item[];
}

declare global {
    interface Window {
        /** Installed by public/scripts-data.js, before the app module runs. */
        SCRIPTING_LIBRARY_DATA?: DashboardData;
    }
}
