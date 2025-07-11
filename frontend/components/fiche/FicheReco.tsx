import { useState } from "react";
import { invoke } from "@tauri-apps/api/core";

const FicheReco = () => {
    const [result, setResult] = useState<string>("");
    const [error, setError] = useState<string>("");
    const path = "./src/core/gathering";

    const printFiche = async () => {
        try {
            const output = await invoke<string>("call_print_checklist", {
                scriptDir: path,
            });
            setResult(output);
            setError("");
        } catch (e: any) {
            setError(e.toString());
        }
    };

    return (
        <>
            <button onClick={printFiche}>PRINT</button>
            <div className="fiche">
                {error && <p style={{ color: "red" }}>{error}</p>}
                <p>{result}</p>
            </div>
        </>
    );
};

export default FicheReco;
