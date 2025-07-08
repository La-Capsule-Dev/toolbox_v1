import { useState } from "react";
import { Command } from "@tauri-apps/plugin-shell";

const FicheReco = () => {
  const [result, setResult] = useState<string>("");
  const [error, setError] = useState<string>("");
  const path = "/home/mtpy/Bureau/toolbox/src-tauri/target/release/toolbox"

  const printFiche = async () => {

    try {
      console.log("Lance la commande");

      const command = Command.create(path);

      const output = await command.execute();
      console.log("Stock le résultat");
      setResult(output.stdout);
      setError("");
      console.log("stdout:", output.stdout);
      console.log("stderr:", output.stderr);
    } catch (e: any) {
      setError(e.message || "Erreur lors de l'exécution du script");
    }
  };

  return (
    <div className="fiche">
      {error && <p style={{ color: "red" }}>{error}</p>}
      <p>{result}</p>
      <button onClick={printFiche}>PRINT</button>
    </div>
  );
};

export default FicheReco;
