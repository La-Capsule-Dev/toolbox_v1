import "./App.css";
import PDFViewer from "./components/tabs/PdfViewer";
import Tabs from "./components/tabs/Tabs";
import Terminal from "./components/tabs/Terminal";
import TestButton from "./components/testButtons/TestButton";
import testScripts from "./testScripts.json";

function App() {
    return (
        <main className="container">
            <section className="ficheContainer">
                <Tabs
                    tabs={[
                        {
                            label: "Fiche PDF",
                            content: <PDFViewer file="/exemple.pdf" />,
                        },
                        {
                            label: "Terminal",
                            content: (
                                <Terminal
                                    script_output={"Aucun script lancé"}
                                />
                            ),
                        },
                    ]}
                />
            </section>
            <section className="buttons">
                {testScripts.map((cat, idx) => (
                    <div key={cat.category}>
                        <h2>{cat.category}</h2>
                        <div key={idx} className="category">
                            {cat.scripts.map((script, idx) => (
                                <TestButton
                                    key={idx}
                                    color={cat.color}
                                    title={script.name}
                                    script={script.scriptPath}
                                />
                            ))}
                        </div>
                    </div>
                ))}
            </section>
        </main>
    );
}

export default App;
