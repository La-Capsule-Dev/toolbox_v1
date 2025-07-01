import { TestButtonProps } from "../../types/TesButtonProps"

const TestButton = (props: TestButtonProps) => {
    const {title, script, color} = props
  return (
    <button style={{backgroundColor: color}} onClick={() => console.log(script)}>
        {title}
    </button>
  )
}

export default TestButton