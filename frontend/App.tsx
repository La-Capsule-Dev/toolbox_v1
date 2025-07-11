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
    const [running, setRunning] = useState<boolean>(false);
    const [timeLeft, setTimeLeft] = useState<number>(190);

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

    const startStressTest = async () => {
        try {
            await invoke("stress_test");
            setRunning(true);
            setTimeLeft(190);
        } catch (e) {
            console.error("Erreur stress test :", e);
        }
    };

    useEffect(() => {
        let interval;
        if (running && timeLeft > 0) {
            interval = setInterval(() => {
                setTimeLeft((prev) => prev - 1);
            }, 1000);
        } else if (timeLeft <= 0) {
            setRunning(false);
        }

        return () => clearInterval(interval);
    }, [running, timeLeft]);

    useEffect(() => {
        startSudoSession();
        invoke<string>("get_pdf_base64")
            .then((dataUri) => {
                setPdfUrl(dataUri);
            })
            .catch(console.error);
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
                                    disabled={
                                        running && script.name === "stress"
                                    }
                                    key={idx}
                                    color={cat.color}
                                    title={
                                        running && script.name === "stress"
                                            ? `${Math.floor(timeLeft / 60)}:${(
                                                  timeLeft % 60
                                              )
                                                  .toString()
                                                  .padStart(2, "0")}`
                                            : script.name
                                    }
                                    launchScript={
                                        script.name == "stress"
                                            ? startStressTest
                                            : () =>
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
