

I made Ranked Tilted Hover Cars Map code #5232-3988-6150 using this :) 

Original Code and creator credit: GloomCraft   gloomcraft.site/ContentHolder/HTMTBRSIU/HTMTBRSIU.html  and  How To Make THE BEST RANK SYSTEM In UEFN (2024) - YouTube

To make this I added another tracker, but set it to track "Eliminated" 

I also changed the code where everything happens in the first widget that constantly updates for the bar instead of a separate function, this makes it so if the rank goes down it also shows on the screen. I couldn't figure out how to make it update using the existing code the way it was, I legit tried a whole bunch of things, but this was my final solution.

My Code:


############################################################
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using {/Verse.org/Simulation/Tags}
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }
using { /Verse.org/Assets }
using { /Verse.org/Colors }
using { /Fortnite.com/UI }


# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

RankProgressBar := class():
    ProgressBarColorBase< private> : color_block = color_block{
        DefaultColor := MakeColorFromHex("000000")
        DefaultDesiredSize := vector2{X:= 250.0, Y := 40.0}} 

    #RankImage: texture= Assets.bronze_1
    RankTextureBlock : texture_block = texture_block{DefaultImage := Assets.bronze_1, DefaultDesiredSize := vector2{X := 210.0, Y := 75.0}}

    var ProgressBarColorTop< private> : color_block = color_block{}  
    var Overlay : overlay = overlay{}

    V2: vector2= vector2{X := 0.07, Y := 0.77}
    V2img: vector2= vector2{X := 0.075, Y := 0.83}
        
    PBarTitleTextBlock< private> : text_block = text_block{DefaultTextColor := MakeColorFromHex("FFFFFF")}

    HPTitleText< private>< localizes>(HPText : string) : message = "{HPText}"

    Init(Current : int, Goal : int):void=
        PBarTitleTextBlock.SetText(HPTitleText("{Current}/{Goal}"))

    #############################

    UpdateWidthAndText(iCurrent : int, Goal : int , img: texture):void=
        var NewCurrent : float = iCurrent * 1.0
        var NewGoal : float = Goal * 1.0

        RankPercentage := NewCurrent / NewGoal
        BarSize := ProgressBarColorBase.GetDesiredSize()
        NewHealthBarWidth := BarSize.X * RankPercentage
        if (Current := float[NewGoal], Total := float[NewGoal]):
            PBarTitleTextBlock.SetText(HPTitleText("{iCurrent}/{Goal}"))
        UpdateHealthBar(NewHealthBarWidth)
        RankTextureBlock.SetImage(img)


    ShowUIForPlayer(Player : player):void=
        if (PlayerUI := GetPlayerUI[Player]):
            if (Fortchar := Player.GetFortCharacter[]):
                if (Instigator : agent = Fortchar.GetAgent[]):
                    PlayerUI.AddWidget(CreateUI(Instigator))

    UpdateHealthBar(NewWidth : float):void=
        Overlay.RemoveWidget(PBarTitleTextBlock)
        Overlay.RemoveWidget(ProgressBarColorTop)
        set ProgressBarColorTop = CreateTopHealthBar(NewWidth)

        Overlay.AddWidget(CreateOverlaySlot(ProgressBarColorTop, horizontal_alignment.Left))
        Overlay.AddWidget(CreateOverlaySlot(PBarTitleTextBlock,horizontal_alignment.Center))
        
    CreateOverlaySlot(TheWidget : widget, HAlignment : horizontal_alignment):overlay_slot=  
        overlay_slot:
            Widget := TheWidget 
            HorizontalAlignment := HAlignment

    CreateTopHealthBar< private>(Width: float):color_block=
        ColorBlock := color_block{
            DefaultColor := MakeColorFromHex("183EFA")
            DefaultDesiredSize := vector2{X:= Width, Y := 40.0}} 
        
        set ProgressBarColorTop = ColorBlock
        

    CreateOverlay< private>(Agent : agent) : overlay=
        TheOverlay := overlay:
            Slots := array:
                overlay_slot:
                    Widget := ProgressBarColorBase
                overlay_slot:
                    Widget := CreateTopHealthBar(1200.0)
                overlay_slot:
                    Widget := PBarTitleTextBlock
        set Overlay = TheOverlay


    CreateUI< private>(Agent : agent) : canvas=
        TheCanvas : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := V2, Maximum := V2}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := V2
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := CreateOverlay(Agent)
                
                canvas_slot:
                    Widget := RankTextureBlock
                    Anchors := anchors{Minimum := V2img, Maximum := V2img}
                    Alignment := V2img            
                                                                
        return TheCanvas


# A Verse-authored creative device that can be placed in a level

AllSpawners := class(tag){}

RankedDevice := class(creative_device):

    var PlayerMap : [agent]PlayerVariable = map{}

    V2: vector2= vector2{X := 0.075, Y := 0.85}

    @editable EliminationTracker : tracker_device = tracker_device{}

    @editable TimesEliminatedTracker : tracker_device = tracker_device{}

    @editable HeadshotTracker : tracker_device = tracker_device{}

    @editable RoundCompletedTracker : tracker_device = tracker_device{}

    Bronze1 : texture = Assets.bronze_1

    Silver1 : texture = Assets.silver_1

    Gold1 : texture = Assets.gold_1

    Platinum1: texture= Assets.platinum_1

    Diamond1: texture = Assets.diamond_1

    Elite1: texture = Assets.elite_1

    Champion1: texture = Assets.champion_1

    Unreal1: texture = Assets.unreal_1

    bronze_upper: int = 100
    silver_upper: int = 200
    gold_upper: int = 300
    platinum_upper: int = 400
    diamond_upper: int = 500
    elite_upper: int = 600
    champion_upper: int = 800
    unreal_upper: int = 1000

    InitSpawners():void =
        Spawners := GetCreativeObjectsWithTag(AllSpawners{})
        for (Obj : Spawners):
            if (Spawner := player_spawner_device[Obj]):
                Spawner.SpawnedEvent.Subscribe(OnPlayerSpawned)

    # Runs when the device is started in a running game
    OnBegin< override>()< suspends>:void=
        # TODO: Replace this with your code
        Print("RankSystem Started")
        InitSpawners()
        GetPlayspace().PlayerRemovedEvent().Subscribe(OnPlayerRemoved)
        Sleep(0.3)
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            Print("Player granted rank")
            OnPlayerSpawned(Player)

    OnPlayerSpawned(Agent : agent):void =
        if (PlayerObj := player[Agent]):
            if (PlayerExists := PlayerMap[Agent]):

            else:
                PV : PlayerVariable = PlayerVariable{AgentOB := Agent}

                PV.RankBar.Init(PV.GetCurrentValue(), PV.GetCurrentGoal())

                PV.RankBar.ShowUIForPlayer(PlayerObj)

                spawn{SetCurrentKills(Agent)}

                #spawn{RankUpdateLoop(Agent, PlayerObj)}

                option:
                    set PlayerMap[Agent] = PV


    SetCurrentKills(Agent : agent)<suspends>:void =
        loop:
            Sleep(0.01)
            if (PV : PlayerVariable = PlayerMap[Agent]):
                var currVal: int =EliminationTracker.GetValue(Agent)+HeadshotTracker.GetValue(Agent)+RoundCompletedTracker.GetValue(Agent) -TimesEliminatedTracker.GetValue(Agent)
                if(currVal < 0):
                    set currVal = 0
                if(currVal >= 0 and currVal<bronze_upper):
                    PV.SetCurrentRankImage(Bronze1)
                    PV.SetCurrentGoal(bronze_upper)
                if(currVal>= bronze_upper and currVal<silver_upper):
                    PV.SetCurrentGoal(silver_upper)
                    PV.SetCurrentRankImage(Silver1)
                if(currVal>= silver_upper and currVal<gold_upper):
                    PV.SetCurrentRankImage(Gold1)
                    PV.SetCurrentGoal(gold_upper)
                if(currVal>= gold_upper and currVal<platinum_upper):
                    PV.SetCurrentRankImage(Platinum1)
                    PV.SetCurrentGoal(platinum_upper)
                if(currVal>=platinum_upper and currVal<diamond_upper):
                    PV.SetCurrentRankImage(Diamond1)
                    PV.SetCurrentGoal(diamond_upper)
                if(currVal>= diamond_upper and currVal<elite_upper):
                    PV.SetCurrentRankImage(Elite1)
                    PV.SetCurrentGoal(elite_upper)
                if(currVal>= elite_upper and currVal<champion_upper):
                    PV.SetCurrentRankImage(Champion1)
                    PV.SetCurrentGoal(champion_upper)
                if(currVal>= champion_upper):
                    PV.SetCurrentRankImage(Unreal1)
                    PV.SetCurrentGoal(unreal_upper)
                PV.SetCurrentValue(currVal)
                PV.RankBar.UpdateWidthAndText(PV.GetCurrentValue(), PV.GetCurrentGoal(), PV.GetCurrentRankImage())
                
            

    OnPlayerRemoved(PlayerLeft : agent):void =
        if (Agent := agent[PlayerLeft]):
            if (ActualPlayer := PlayerMap[Agent]):
                var TempAllPlayerMap : [agent]PlayerVariable = map{}
                for (Key -> Value : PlayerMap, Key <> Agent):
                    set TempAllPlayerMap = ConcatenateMaps(TempAllPlayerMap, map{Key => Value})

                set PlayerMap = TempAllPlayerMap

#--END OF RANK SYSTEM SCRIPT--

#--START OF PLAYER CLASS--


PlayerVariable := class():
    AgentOB : agent

    RankBar : RankProgressBar = RankProgressBar{}

    var CurrentGoal : int = 0

    var CurrentValue : int = 0

    var rankImage: texture= Assets.bronze_1

    GetCurrentGoal() : int =
        return CurrentGoal
    
    SetCurrentGoal(Change : int) : int =
        set CurrentGoal = Change

    GetCurrentValue() : int =
        return CurrentValue
    
    SetCurrentValue(Change : int) : int =
        set CurrentValue = Change

    SetCurrentRankImage(img: texture): void=
        set rankImage= img

    GetCurrentRankImage(): texture=
        return rankImage
