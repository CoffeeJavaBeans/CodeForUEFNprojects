using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

#Gloomcraft Code https://gloomcraft.site/Shop.html
#Gloomcraft Video https://www.youtube.com/watch?v=pLnpfoXFR3c&t=77s

#Verse Documentation https://dev.epicgames.com/documentation/en-us/uefn/using-persistable-data-in-verse

#Start code https://github.com/CoffeeJavaBeans/CodeForUEFNprojects/blob/main/SaveWithoutSpanwers.verse


TextForUI< localizes>(InText : string) : message = "Coins: {InText}"

player_data := class< final>< persistable>{
    Gold : int = 0

    #Initialize Stats for current players
    InitializeAllPlayers(Players:[]player):void=
        for(Player: Players):
            InitializePlayer(Player)

    #Initialize for one player
    InitializePlayer(Player:player):void=
        if:
            not Data[Player]
            set Data[Player] = player_data{}
}

player_data_update< constructor>(OldStat:player_data)< transacts> := player_data {
    Gold := OldStat.Gold
}

var Data:weak_map(player, player_data) = map{}

Make_screen_UI:=class(){
    MaybePlayer<internal>:?agent=false
    MaybePlayerUI<internal>:?player_ui=false

    var Canvas<internal>:canvas=canvas{}
    GoldWidget<internal>:text_block=text_block{DefaultTextColor :=NamedColors.White}
    GoldText<localizes><internal>(CurrentTotalGold:int): message = "Gold: {CurrentTotalGold}"
    var TotalGold<private>:int=0

    block:
        set Canvas=canvas:
            Slots:=array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X:=0.0,Y:=0.55} , Maximum := vector2{X:=0.0, Y:=0.55}}
                    Offsets := margin{Top :=0.0, Left:=25.0, Right :=0.0, Bottom :=0.0}
                    Alignment := vector2{X:=0.0, Y:=0.0}
                    SizeToContent :=true
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots:=array:
                            stack_box_slot:
                                HorizontalAlignment := horizontal_alignment.Left
                                Widget := GoldWidget

    IncreaseGold<public>(Player : player, gold:int):void=
        if(PlayerObj := player[Player]):
            if:
                OldData:=Data[PlayerObj]
                    set Data[PlayerObj] = player_data{
                        player_data_update<constructor>(OldData)
                        Gold := OldData.Gold+gold
                    }
                    set TotalGold = OldData.Gold
            UpdateUI()
                
    UpdateUI<private>():void=
        if(PlayerUI := MaybePlayerUI?):
            GoldWidget.SetText(GoldText(TotalGold))

    AddToUI<public>():void=
        if(PlayerUI := MaybePlayerUI?):
            PlayerUI.AddWidget(Canvas)
            UpdateUI()


}

MakeScreen<constructor><public>(Agent:agent):=
    Make_screen_UI:
        MaybePlayer:=option{Agent}
        MaybePlayerUI:=option{GetPlayerUI[player[Agent]]}



# A Verse-authored creative device that can be placed in a level
Persist_without_SaveDevice := class(creative_device):

    var screeenmanagerplayersdict : [player]Make_screen_UI= map{}
    var NonSpawnerPlayerWay :player_data=player_data{}
    #var screenmanagerforplayer1: Make_screen_UI = Make_screen_UI{} For an individual player only
 
    @editable Increase : button_device = button_device{}

    @editable Decrease : button_device = button_device{}

    InitPlayers():void=
        AllPlayers := GetPlayspace().GetPlayers()
        NonSpawnerPlayerWay.InitializeAllPlayers(AllPlayers)
        #if(Player1:=AllPlayers[0]):  Individual player only
        #    set screenmanagerforplayer1 =MakeScreen(Player1)
        #    screenmanagerforplayer1.AddToUI()
        #Instead make a dictionary to do this for all players
        for(Player: AllPlayers):
            theUI:=MakeScreen(Player)
            theUI.AddToUI()
            if(set screeenmanagerplayersdict[Player] = theUI):
        


    IncreaseGold(Agent : agent) : void = {
        if (PlayerObj := player[Agent]) {
            #screenmanagerforplayer1.IncreaseGold(PlayerObj,1) One Player ONLY
            #Use dictionary for all players
            if(theplayerUI:=screeenmanagerplayersdict[PlayerObj]):
                theplayerUI.IncreaseGold(PlayerObj,1)

        }
    }

    DecreaseGold(Agent : agent) : void = {
        if (PlayerObj := player[Agent]) {
            #screenmanagerforplayer1.IncreaseGold(PlayerObj,-1)
            if(theplayerUI:=screeenmanagerplayersdict[PlayerObj]):
                theplayerUI.IncreaseGold(PlayerObj,-1)
        }
    }


    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        
        InitPlayers()
        
        Increase.InteractedWithEvent.Subscribe(IncreaseGold)

        Decrease.InteractedWithEvent.Subscribe(DecreaseGold)

