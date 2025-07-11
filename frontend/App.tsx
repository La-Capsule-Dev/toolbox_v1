import { useEffect, useState } from "react";
import "./App.css";
import PDFViewer from "./components/tabs/PdfViewer";
import Tabs from "./components/tabs/Tabs";
import Terminal from "./components/tabs/Terminal";
import TestButton from "./components/testButtons/TestButton";
import testScripts from "./testScripts.json";
import { invoke } from "@tauri-apps/api/core";
import CPUTemperature from "./components/CPUTemperature";

function App() {
    const [PdfUrl, setPdfUrl] = useState<string>("");

    const startSudoSession = async () => {
        try {
            await invoke("start_session");
        } catch (error) {
            console.log(error);
        }
    };

    const rust_script = (script: string) => {
        invoke(script);
    };

    useEffect(() => {
        invoke<string>("get_pdf_base64")
            .then((dataUri) => {
                setPdfUrl(dataUri);
            })
            .catch(console.error);
        startSudoSession();
    }, []);

    return (
        <main className="container">
            <CPUTemperature />
            <section className="ficheContainer">
                <Tabs
                    tabs={[
                        {
                            label: "Fiche PDF",
                            content: <PDFViewer file={PdfUrl} />,
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
                                    launchScript={() =>
                                        rust_script(script.scriptCmd)
                                    }
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
