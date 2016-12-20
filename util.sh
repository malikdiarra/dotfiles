sum(){
  # Sum a list of integers received in stdin
  awk '{s+=$1} END {print s}'
}
