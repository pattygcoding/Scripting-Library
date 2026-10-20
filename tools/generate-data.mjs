// Generates public/scripts-data.js from the real repository: the dashboard is a
// viewer for what is actually committed, so this walks the six language folders
// under `scripts/`, reads each script's source and the README that sits beside it,
// and writes one payload the app can read without a fetch.  `npm run data` runs it,
// and the build runs it again, so a script added to a folder appears on the site
// without an app change.
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync, statSync, writeFileSync } from "node:fs";
import { dirname, extname, join } from "node:path";
import { fileURLToPath } from "node:url";

// tools/ -> the repository root.
const ROOT = dirname(dirname(fileURLToPath(import.meta.url)));

// Every language folder lives under this one directory, so the repository root holds
// the showcase and a single tree of scripts beside it.  A language's own `folder` is
// just its name; every path the payload records is from the repository root, because
// that is what the GitHub links are built from.
const SCRIPTS_DIR = "scripts";

// The repository-relative path of a language folder or one of the script folders
// inside it: `scripts/powershell`, or `scripts/powershell/Update Git`.
function scriptsPath(...parts) {
    return [SCRIPTS_DIR, ...parts].join("/");
}

// The language folders, in the order the README lists them.  `primary` is the order
// a folder's files are preferred in: the spreadsheet scripts ship a .vba, a .gs and
// an experimental .ts, and the .vba is the one this library is named for.  `slug` is
// the folder's address segment (`/powershell`), `description` is the one line the
// home page card shows, and `color` is a legible accent derived from the language's
// own brand colour, used by that card on the navy canvas.
const LANGUAGES = [
    {
        folder: "bash",
        name: "Bash",
        slug: "bash",
        extension: ".sh",
        prism: "language-bash",
        primary: [".sh"],
        color: "#4EAA25",
        description: "Shell scripts for development, git and system utilities.",
    },
    {
        folder: "lua",
        name: "Lua",
        slug: "lua",
        extension: ".lua",
        prism: "language-lua",
        primary: [".lua"],
        color: "#6C7CFF",
        description: "Standalone Lua utilities, from file surveying to git.",
    },
    {
        folder: "powershell",
        name: "PowerShell",
        slug: "powershell",
        extension: ".ps1",
        prism: "language-powershell",
        primary: [".ps1"],
        color: "#5391FE",
        description: "Windows terminal and $profile helper functions.",
    },
    {
        folder: "python",
        name: "Python",
        slug: "python",
        extension: ".py",
        prism: "language-python",
        primary: [".py"],
        color: "#4A9EE8",
        description: "General purpose Python utilities.",
    },
    {
        folder: "ruby",
        name: "Ruby",
        slug: "ruby",
        extension: ".rb",
        prism: "language-ruby",
        primary: [".rb"],
        color: "#E0503F",
        description: "Ruby equivalents of the common utilities.",
    },
    {
        folder: "vba",
        name: "VBA",
        slug: "vba",
        extension: ".vba",
        prism: "language-visual-basic",
        primary: [".vba", ".gs", ".ts"],
        color: "#21A366",
        description: "VBA, Google Apps Script and Office Script for Excel and Sheets.",
    },
];

const DEFAULT_REPOSITORY = "https://github.com/pattygcoding/Scripting-Library";

// Read a file as text.  Line endings are normalised to LF: git stores LF, but a
// Windows checkout with `core.autocrlf=true` hands back CRLF, and the generator must
// produce the same payload on a developer's machine and on the Linux runner.
function readText(path) {
    return readFileSync(path, "utf8").replace(/^\uFEFF/, "").replace(/\r\n/g, "\n");
}

// A folder name as an address slug: `Clear Git` -> `clear-git`, `Update GIt` ->
// `update-git`.  The result always matches the 404 shim's slug pattern, so a deep
// link can be typed by hand.
function slug(text) {
    return text
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, "-")
        .replace(/^-+|-+$/g, "");
}

function pickPrimary(sources, preferred) {
    for (const extension of preferred) {
        const match = sources.find((file) => file.toLowerCase().endsWith(extension));
        if (match) {
            return match;
        }
    }
    return sources[0];
}

// The first sentence of a README, for the card the language page draws: the READMEs
// open with a title, then a line or two saying what the script does, then their
// sections.  Markdown decoration is stripped so the result reads as prose wherever
// it is placed.
function firstSentence(readme) {
    if (!readme) {
        return "";
    }
    const paragraph = [];
    for (const line of readme.split("\n")) {
        const text = line.trim();
        if (text === "") {
            if (paragraph.length > 0) {
                break;
            }
            continue;
        }
        // Anything that is not prose - a heading, a fence, a list item, a table row,
        // a raw HTML tag - ends the summary paragraph, or is skipped before it starts.
        if (/^(#|```|>|\||[-*+]\s|\d+[.)]\s|<)/.test(text)) {
            if (paragraph.length > 0) {
                break;
            }
            continue;
        }
        paragraph.push(text);
    }
    let prose = paragraph
        .join(" ")
        .replace(/!\[[^\]]*\]\([^)]*\)/g, "")
        .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
        .replace(/`([^`]*)`/g, "$1")
        .replace(/\*\*([^*]+)\*\*/g, "$1")
        .replace(/\s+/g, " ")
        .trim();
    const stop = prose.search(/[.!?](\s|$)/);
    if (stop > 0 && stop < 200) {
        prose = prose.slice(0, stop + 1);
    } else if (prose.length > 160) {
        prose = prose.slice(0, 157).replace(/\s+\S*$/, "") + "...";
    }
    return prose;
}

// One script folder -> one item.  `docs` is absent for the folders that ship no
// README, which is what hides the Documentation tab for them.
function collectScripts(language) {
    const languageDir = join(ROOT, SCRIPTS_DIR, language.folder);
    if (!existsSync(languageDir)) {
        return [];
    }
    const items = [];
    for (const entry of readdirSync(languageDir).sort(compare)) {
        if (entry.startsWith(".")) {
            continue;
        }
        const scriptDir = join(languageDir, entry);
        if (!statSync(scriptDir).isDirectory()) {
            continue;
        }
        const files = readdirSync(scriptDir)
            .filter((file) => !file.startsWith("."))
            .filter((file) => statSync(join(scriptDir, file)).isFile())
            .sort(compare);
        const sources = files.filter((file) => file.toLowerCase() !== "readme.md");
        if (sources.length === 0) {
            continue;
        }
        const primary = pickPrimary(sources, language.primary);
        const others = sources.filter((file) => file !== primary);
        const readme = files.find((file) => file.toLowerCase() === "readme.md");
        const docs = readme ? readText(join(scriptDir, readme)) : "";
        items.push({
            // The address is the language segment plus the script segment:
            // /powershell/update-git.  Keeping the `/` in the id means the router, the
            // links and `itemById` all speak one identifier.
            id: language.slug + "/" + slug(entry),
            slug: slug(entry),
            name: entry,
            language: language.name,
            languageSlug: language.slug,
            prism: language.prism,
            file: scriptsPath(language.folder, entry, primary),
            folder: scriptsPath(language.folder, entry),
            extension: extname(primary).toLowerCase(),
            ...(firstSentence(docs) ? { summary: firstSentence(docs) } : {}),
            ...(others.length > 0 ? { note: "Also in this folder: " + others.join(", ") + "." } : {}),
            ...(docs ? { docs } : {}),
            code: readText(join(scriptDir, primary)),
        });
    }
    return items;
}

// Code-unit order, so the payload does not depend on the machine's locale.
function compare(a, b) {
    const left = a.toLowerCase();
    const right = b.toLowerCase();
    if (left === right) {
        return a < b ? -1 : a > b ? 1 : 0;
    }
    return left < right ? -1 : 1;
}

// `git remote get-url origin` in CI (actions/checkout leaves origin set), so a fork
// marks its own repository; GITHUB_REPOSITORY covers a checkout without a remote, and
// the committed default covers a source tarball.
function repositoryUrl() {
    try {
        const remote = execFileSync("git", ["remote", "get-url", "origin"], {
            cwd: ROOT,
            encoding: "utf8",
            stdio: ["ignore", "pipe", "ignore"],
        }).trim();
        const web = remote
            .replace(/^git@([^:]+):/, "https://$1/")
            .replace(/^ssh:\/\/git@([^/]+)\//, "https://$1/")
            .replace(/\.git$/, "");
        if (web.startsWith("http")) {
            return web;
        }
    } catch {
        // no git, or no origin: fall through
    }
    const repoSlug = process.env.GITHUB_REPOSITORY;
    return repoSlug ? "https://github.com/" + repoSlug : DEFAULT_REPOSITORY;
}

// The branch the per-folder GitHub links point at.  A CI checkout is detached, so
// GITHUB_REF_NAME wins there; otherwise ask git.
function branchName() {
    if (process.env.GITHUB_REF_NAME) {
        return process.env.GITHUB_REF_NAME;
    }
    try {
        const branch = execFileSync("git", ["rev-parse", "--abbrev-ref", "HEAD"], {
            cwd: ROOT,
            encoding: "utf8",
            stdio: ["ignore", "pipe", "ignore"],
        }).trim();
        return branch || "main";
    } catch {
        return "main";
    }
}

// Two folders in one language can slugify alike (`Update GIt` / `Update Git`), which
// would make two rows share an address; the later one is suffixed rather than
// dropped, so nothing in the repository goes unlisted.
function uniqueIds(items) {
    const seen = new Set();
    for (const item of items) {
        let id = item.id;
        let suffix = 2;
        while (seen.has(id)) {
            id = item.id + "-" + suffix;
            suffix += 1;
        }
        item.id = id;
        seen.add(id);
    }
}

function main() {
    const languages = [];
    const scripts = [];
    for (const language of LANGUAGES) {
        const items = collectScripts(language);
        if (items.length === 0) {
            continue;
        }
        const readmePath = join(ROOT, SCRIPTS_DIR, language.folder, "README.md");
        languages.push({
            name: language.name,
            slug: language.slug,
            extension: language.extension,
            prism: language.prism,
            color: language.color,
            description: language.description,
            // The folder the language lives in, for its GitHub link, and the folder's
            // own README, which its page shows as the language's overview.
            folder: scriptsPath(language.folder),
            ...(existsSync(readmePath) ? { docs: readText(readmePath) } : {}),
            count: items.length,
        });
        scripts.push(...items);
    }
    uniqueIds(scripts);

    const payload = {
        meta: {
            updated: new Date().toISOString().slice(0, 10),
            languageCount: languages.length,
            scriptCount: scripts.length,
            documentedCount: scripts.filter((script) => script.docs).length,
            repository: repositoryUrl(),
            branch: branchName(),
        },
        languages,
        scripts,
    };

    const banner =
        "// Generated by tools/generate-data.mjs from the script folders - do not edit by hand.\n" +
        "// Regenerate with `npm run data` (the build runs it too).\n";
    writeFileSync(
        join(ROOT, "public", "scripts-data.js"),
        banner + "window.SCRIPTING_LIBRARY_DATA = " + JSON.stringify(payload, null, 4) + ";\n",
        "utf8",
    );

    const counts = languages.map((language) => language.name + " " + language.count).join(", ");
    console.log(
        "scripts-data.js: " + payload.meta.scriptCount + " scripts in " + payload.meta.languageCount +
        " languages (" + counts + "); " + payload.meta.documentedCount + " documented",
    );
}

main();
