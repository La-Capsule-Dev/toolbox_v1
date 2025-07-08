import "./App.css";
import FicheReco from "./components/fiche/FicheReco";
import TestButton from "./components/testButtons/TestButton";
import testScripts from './testScripts.json'

function App() {

  return (
    <main className="container">
      <section className="ficheContainer">
        <FicheReco />
      </section>
      <section className="buttons">
        {testScripts.map((cat, idx) => (
          <>
            <h2>{cat.category}</h2>
          <div key={idx} className="category">
            {cat.scripts.map((script, idx) => (
              <TestButton key={idx} color={cat.color} title={script.name} script={script.scriptPath} />
            ))}
          </div>
          </>
        ))}
      </section>
    </main>
  );
}

export default App;
