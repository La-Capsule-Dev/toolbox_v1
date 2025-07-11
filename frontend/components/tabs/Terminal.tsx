const Terminal = ({ script_output }) => {
    return (
        <textarea name="terminal" id="terminal">
            {script_output}
        </textarea>
    );
};

export default Terminal;
