#Code snippets- this won't run as is, these are snippets from a larger project

BoardText<localizes>(count : int) : message = "{count}"

@editable var HintMessage: billboard_device=billboard_device{}
@editable var Hint: button_device=button_device{} 

var hintsGranted: int= 0

Hint.InteractedWithEvent.Subscribe(GetHint)

HintMessage.SetText(BoardText("Hint {hintsGranted} Granted."))
set hintsGranted+=1
