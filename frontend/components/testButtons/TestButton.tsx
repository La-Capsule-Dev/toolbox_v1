import { TestButtonProps } from "../../types/TesButtonProps";

const TestButton = (props: TestButtonProps) => {
    const { title, launchScript, color, disabled } = props;
    return (
        <button
            disabled={disabled}
            style={{ backgroundColor: color }}
            onClick={launchScript}>
            {title}
        </button>
    );
};

export default TestButton;
