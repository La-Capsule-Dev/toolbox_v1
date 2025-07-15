type PopupProps = {
    visibility: "visible" | "hidden";
    close: () => void;
    message: string;
    color: "#10b981" | "#F97316";
};

const Popup = (props: PopupProps) => {
    const { visibility, close, message, color } = props;
    return (
        <div className="overlay" style={{ visibility: visibility }}>
            <div className="popup" style={{ background: color }}>
                <h4>{message}</h4>
                <button onClick={close}>Fermer</button>
            </div>
        </div>
    );
};

export default Popup;
