#You will need
# 3 button devices
# 1 Billboard device
# 1 Verse device
# And Devices alreay in a blank project when you open UEFN

#Class documentation
#https://dev.epicgames.com/documentation/en-us/uefn/class-in-verse
#Constructor documentation
#https://dev.epicgames.com/documentation/en-us/uefn/constructor-in-verse?application_version=1.0

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }


ButtonTag1:=class(tag){}
ButtonTag2:=class(tag){}
ButtonTag3:=class(tag){}
BillboardTag1:=class(tag){}

ButtonPressedClass:=class{
    theMessage1: int
    theMessage2: int
    theMessage3: int
    tag1: tag
    tag2: tag
    tag3: tag
    

    TheBillboardText<localizes>(thetext : string) : message = "{thetext}"


    Button1Init():void=
        buttonOne:=GetCreativeObjectsWithTag(tag1)
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,theMessage1)

    Button2Init():void=
        buttonOne:=GetCreativeObjectsWithTag(tag2)
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,theMessage2)

    Button3Init():void=
        buttonOne:=GetCreativeObjectsWithTag(tag3)
        for(Obj : buttonOne):
            if(b :=button_device[Obj]):
                b.InteractedWithEvent.SubscribeAgent(buttonNPressed,theMessage3)
        


    buttonNPressed(Agent: agent, Text: int): void=
        billOne:=GetCreativeObjectsWithTag(BillboardTag1{})
        for(Obj : billOne):
            if(billboard1:=billboard_device[Obj]):
                billboard1.SetText(TheBillboardText("You pressed button {ToString(Text)}"))
                billboard1.UpdateDisplay()
                billboard1.ShowText()


}

PassInMessage<constructor>(m1: int, m2: int, m3: int, t1: tag, t2: tag, t3: tag) := ButtonPressedClass:
    theMessage1:= m1
    theMessage2:= m2
    theMessage3:= m3
    tag1:=t1
    tag2:=t2
    tag3:=t3

        

ButtonDevice := class(creative_device):

    
    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=

        bpc:=PassInMessage(1,2,3,ButtonTag1{}, ButtonTag2{}, ButtonTag3{})
        bpc.Button1Init()
        bpc.Button2Init()
        bpc.Button3Init()
       
    
#https://dev.epicgames.com/community/snippets/d8k/fortnite-wrapping-subscribe-to-pass-additional-data-to-listeners


using { /Verse.org/Simulation }

(Listenable : listenable(agent)).SubscribeAgent(OutputFunc : tuple(agent, t)->void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_agent(t){ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_agent(t : type) := class():
    ExtraData : t;
    OutputFunc : tuple(agent, t) -> void
    InputFunc(Agent : agent):void = OutputFunc(Agent, ExtraData)

(Listenable : listenable(tuple())).SubscribeEmpty(OutputFunc : t -> void, ExtraData : t where t:type) : cancelable =
    Wrapper := wrapper_empty(t) {ExtraData := ExtraData, OutputFunc := OutputFunc}
    Listenable.Subscribe(Wrapper.InputFunc)

wrapper_empty(t : type) := class():
    ExtraData : t;
    OutputFunc : t -> void
    InputFunc():void = OutputFunc(ExtraData)
