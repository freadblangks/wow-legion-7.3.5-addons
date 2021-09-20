Adapt

This addon animates the unit frames of (nearly) any UI.

When the UI goes to draw a static portrait, this addon instead draws an animated model to the dimensions of the intended portrait. 

Adapt is meant to be configuration-free (especially if you use the default unit frames), but there are some options you can change in its Interface Options Panel.

=== FAQ

Q: Will it work with my custom unit frames?
A: If your existing unit frames are static portraits and not models already, yes it should. The universal approach this addon takes will attempt to convert any 2d portrait texture into a 3d model (if it's bigger than 30 pixels). However, if Adapt already came with the unit frame addon or UI compilation you use, you may need to get an updated version of that addon/compilation if it made any tweaks to portraits/Adapt.

Q: It's not working or there's a bug.
A: I'd love to hear about it in the comments. Please mention what Unit Frame addon or UI compilation you use.

Q: I use circular unit frames (like default), but when I look closely the model cut off as a square! Can the model be fit into a true circle?
A: Sadly, it can't. Addons have no genuine way to mask models. For circular unit frames the model is shrunk to fit within the circle.

Q: I want to disable my default focus frame from animating, but I don't see it in the options list.
A: The list in options is only of portraits it's encountered in that session (and those already disabled). Adapt has no idea what frames it will be asked to draw until it encounters them. So in this case you can /focus yourself and when you go back into options the focus frame should be listed so you can disable it.

__ Changelog __

08/29/2017 version 2.2.5
- toc update for 7.3 patch

03/28/2016 version 2.2.4
- toc update for 7.2 patch

10/24/2016 version 2.2.3
- toc update for 7.1 patch

07/03/2016 version 2.2.2
- Also workaround for UNIT_MODEL_CHANGED not firing when a player unghosts, causing their model to remain in ghostly form.

07/03/2016 version 2.2.1
- Workaround for UNIT_MODEL_CHANGED not firing when a warrior finishes "leap" out of Skyhold, causing fiery/explody model to continue.

05/14/2016 version 2.2.0
- toc update for 7.0 Legion Beta
- Fix for first render not working on a new model

01/21/2016 version 2.1.0
- Rewrote options panel.
- Restructured settings (some with non-standard settings may need to set them back).
- Added new option "With Overlay Mask" to add a circular texture over models to soften the corners and make them more round.
- Added new option "Smaller Portrait" to bring round portraits in even further.
- "Torso Portrait" mode reworked: model turned to "default rotation" and zoomed in just a bit for a more natural view.
- "Full Model" mode zoomed in a bit.
- All animations now (theoretically) use a standing animation without idle animations (such as undead going off camera).
- Fixed camera issue when changing the UI scale or display size.

2.0.17 01/15/16 brought corners in slightly for "circle" portraits
2.0.16 06/22/15 toc update for 6.2 patch
2.0.15 02/24/15 toc update for 6.1 patch
2.0.14 10/30/14 fix for frames being removed from blacklist staying on blacklist
2.0.13 10/29/14 fix for achievement comparison portrait
2.0.12 10/14/14 6.0 patch
2.0.11 4/9/14 torso portrait option
2.0.10 10/27/13 fix for blacklisted portraits belonging to an addon that later gets disabled
2.0.9 09/11/13 toc update for 5.4 patch
2.0.8 05/21/13 toc update for 5.3 patch
2.0.7 04/04/13 added blacklist cache, removed debug code
2.0.6 03/30/13 big rewrite: portraits indexed by the texture itself, not the texture name; instead of a frame with back and model drawn off it, back and model drawn straight to parent of original texture; useParentLevel inherited by models; setCamera replaced with SetPortraitZoom; instead of reacting to every SetPortraitTexture, a SetUnit done only if the GUID changed. At the same time, if a UNIT_MODEL_CHANGED happens, every portrait of that unit will be updated at a lower priority update; rebuilt options frame
1.92 08/28/12 fixed _ tainting
1.91 08/27/12 5.0 (Mists of Pandaria) update
1.9  09/02/10 4.0 (Cataclysm) support, TargetFrameToTPortrait defaulted DontUse
1.82 10/08/08 scroll fix, /adapt goes to options panel
1.81 08/08/08 updated for WotLK (toc, this->self)
1.8  04/12/08 moved options to new interface options, added full model option
1.71 01/12/07 fixed initialization
1.7  01/11/07 fixed taint issue with default ToT
1.6  10/04/06 edits for lua 5.1
1.5  08/21/06 changed DressUpModel to PlayerModel, moved SetCamera OnUpdate to OnShow
1.4  06/22/06 disabled mouse on portraits, added known frames to /adapt list
1.3  06/11/06 /adapt animate/unanimate options, visibility fix by Lafiell, attempt at more flexibility with frameStrata
1.2  04/01/06 slash options added for circle/square portraits and background
1.0  03/19/06 initial release
