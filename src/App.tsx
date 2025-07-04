import { useState } from "react";
import "./App.css";
import FicheReco from "./components/fiche/FicheReco";
import TestButton from "./components/testButtons/TestButton";
import testScripts from './testScripts.json'
import { Command } from "@tauri-apps/plugin-shell";

function App() {
  const path = "/home/mtpy/Bureau/toolbox/scripts"
  const [temperature, setTemperature] = useState<string[]>([])
  
  const printTemp = async () => {
    const command = Command.create('exec-sh', [`${path}/stress.sh`])
    command.stdout.on('data', (line) => {
      setTemperature(prev => [...prev, line]);
    });
    await command.execute();
  }

  return (
    <main className="container">
      <section className="temperature">
        {temperature}
      </section>
      <section className="ficheContainer">
        <FicheReco />
      </section>
      <section className="buttons">
        {testScripts.map((cat, idx) => (
          <>
            <h2>{cat.category}</h2>
          <div key={idx} className="category">
            {cat.scripts.map((script, idx) => (
              <TestButton key={idx} color={cat.color} title={script.name} script={script.name === "stress" ? printTemp : () => null} />
            ))}
          </div>
          </>
        ))}
      </section>
    </main>
  );
}

export default App;
