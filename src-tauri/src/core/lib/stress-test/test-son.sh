
function testSon
{
    mplayer /usr/share/LACAPSULE/MULTITOOL/Test/test.wav > /dev/null 2>&1 &
    echo "Test du son" > $OUTPUT
    display_output 20 60 "Message"
}
