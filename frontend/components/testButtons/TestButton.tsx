import { TestButtonProps } from "../../types/TesButtonProps";

const TestButton = (props: TestButtonProps) => {
    const { title, launchScript, color } = props;
    return (
        <button style={{ backgroundColor: color }} onClick={launchScript}>
            {title}
        </button>
    );
};

export default TestButton;
