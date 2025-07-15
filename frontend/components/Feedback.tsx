type FeedbackType = "stress" | "micro" | "custom" | null;

type Props = {
    type: FeedbackType;
    message?: string;
    color?: string;
    volume?: number;
    onClose: () => void;
    visible: boolean;
};

export default function Feedback({
    type,
    message,
    color = "#F97316",
    volume = 0,
    onClose,
    visible,
}: Props) {
    if (!visible) return null;

    return (
        <div className="overlay">
            <div
                className="popup"
                style={{
                    backgroundColor: "#fff",
                    borderRadius: "1rem",
                    padding: "1.5rem",
                    boxShadow: "0 0 20px rgba(0,0,0,0.3)",
                    width: "min(90%, 400px)",
                    textAlign: "center",
                }}>
                {type === "stress" && (
                    <>
                        <h4 style={{ color }}>{message}</h4>
                        <button onClick={onClose}>Fermer</button>
                    </>
                )}

                {type === "micro" && (
                    <>
                        <h4>Niveau du micro</h4>
                        <div
                            style={{
                                backgroundColor: "#eee",
                                height: "10px",
                                borderRadius: "5px",
                                overflow: "hidden",
                                marginTop: "1rem",
                            }}>
                            <div
                                style={{
                                    width: `${volume}%`,
                                    backgroundColor: "#10b981",
                                    height: "100%",
                                    transition: "width 0.1s ease",
                                }}
                            />
                        </div>
                        <p style={{ marginTop: "0.5rem" }}>{volume} %</p>
                    </>
                )}

                {type === "custom" && <p>{message}</p>}
            </div>
        </div>
    );
}
