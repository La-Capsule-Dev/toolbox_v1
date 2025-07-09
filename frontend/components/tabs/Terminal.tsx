import { useState } from "react";
import { invoke } from "@tauri-apps/api/core";

type TerminalProps = {
    scriptPath: string;
};

export default function Terminal({ scriptPath }: TerminalProps) {
    const [output, setOutput] = useState<string>("");
    const [needSudo, setNeedSudo] = useState<boolean>(false);
    const [sudoPwd, setSudoPwd] = useState<string>("");

    const runScript = async (password?: string) => {
        try {
            const result = await invoke<string>("run_script", {
                path: scriptPath,
                password: password || null,
            });
            setOutput(result);
            setNeedSudo(false);
        } catch (err: any) {
            // Si Rust renvoie une erreur spécifique "SUDO_PASSWORD_REQUIRED"
            if (err.message === "SUDO_PASSWORD_REQUIRED") {
                setNeedSudo(true);
            } else {
                setOutput(`Erreur : ${err.message}`);
            }
        }
    };

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        runScript(sudoPwd);
        setSudoPwd("");
    };

    return (
        <div className="terminal">
            <button onClick={() => runScript()}>Lancer le script</button>
            <pre>{output}</pre>
            {needSudo && (
                <form onSubmit={handleSubmit}>
                    <label>
                        Mot de passe sudo :
                        <input
                            type="password"
                            value={sudoPwd}
                            onChange={(e) => setSudoPwd(e.target.value)}
                        />
                    </label>
                    <button type="submit">Valider</button>
                </form>
            )}
        </div>
    );
}
