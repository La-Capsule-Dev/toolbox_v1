import { useState } from "react";
import { Command } from "@tauri-apps/plugin-shell";

const FicheReco = () => {
  const [result, setResult] = useState<string>("");
  const [error, setError] = useState<string>("");
  const path = "/home/mtpy/Bureau/toolbox/src/scripts"

  const printFiche = async () => {
    try {
      const command = Command.create("bash", [`${path}/fiche/PRINT.sh`]);
      const output = await command.execute();
      setResult(output.stdout);
      setError("");
      console.log("stdout:", output.stdout);
      console.log("stderr:", output.stderr);
    } catch (e: any) {
      setError(e.message || "Erreur lors de l'exécution du script");
      setResult("");
    }
  };

  return (
    <div>
      <button onClick={printFiche}>PRINT</button>
      {error && <p style={{ color: "red" }}>{error}</p>}
      <p>{result}</p>
    </div>
  );
};

export default FicheReco;
