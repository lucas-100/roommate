// Copyright (c) 2005-2008 Thomas Fuchs (http://script.aculo.us, http://mir.aculo.us)
//           (c) 2005-2008 Sammi Williams (http://www.oriontransfer.co.nz, sammi@oriontransfer.co.nz)
//
// script.aculo.us is freely distributable under the terms of an MIT-style license.
// For details, see the script.aculo.us web site: http://script.aculo.us/
if(Object.isUndefined(Effect))throw"dragdrop.js requires including script.aculo.us' effects.js library";var Droppables={drops:[],remove:function(a){this.drops=this.drops.reject(function(b){return b.element==$(a)})},add:function(a){a=$(a);var b=Object.extend({greedy:!0,hoverclass:null,tree:!1},arguments[1]||{});if(b.containment){b._containers=[];var c=b.containment;Object.isArray(c)?c.each(function(a){b._containers.push($(a))}):b._containers.push($(c))}b.accept&&(b.accept=[b.accept].flatten()),Element.makePositioned(a),b.element=a,this.drops.push(b)},findDeepestChild:function(a){deepest=a[0];for(i=1;i<a.length;++i)Element.isParent(a[i].element,deepest.element)&&(deepest=a[i]);return deepest},isContained:function(a,b){var c;return b.tree?c=a.treeNode:c=a.parentNode,b._containers.detect(function(a){return c==a})},isAffected:function(a,b,c){return c.element!=b&&(!c._containers||this.isContained(b,c))&&(!c.accept||Element.classNames(b).detect(function(a){return c.accept.include(a)}))&&Position.within(c.element,a[0],a[1])},deactivate:function(a){a.hoverclass&&Element.removeClassName(a.element,a.hoverclass),this.last_active=null},activate:function(a){a.hoverclass&&Element.addClassName(a.element,a.hoverclass),this.last_active=a},show:function(a,b){if(!this.drops.length)return;var c,d=[];this.drops.each(function(c){Droppables.isAffected(a,b,c)&&d.push(c)}),d.length>0&&(c=Droppables.findDeepestChild(d)),this.last_active&&this.last_active!=c&&this.deactivate(this.last_active),c&&(Position.within(c.element,a[0],a[1]),c.onHover&&c.onHover(b,c.element,Position.overlap(c.overlap,c.element)),c!=this.last_active&&Droppables.activate(c))},fire:function(a,b){if(!this.last_active)return;Position.prepare();if(this.isAffected([Event.pointerX(a),Event.pointerY(a)],b,this.last_active)&&this.last_active.onDrop)return this.last_active.onDrop(b,this.last_active.element,a),!0},reset:function(){this.last_active&&this.deactivate(this.last_active)}},Draggables={drags:[],observers:[],register:function(a){this.drags.length==0&&(this.eventMouseUp=this.endDrag.bindAsEventListener(this),this.eventMouseMove=this.updateDrag.bindAsEventListener(this),this.eventKeypress=this.keyPress.bindAsEventListener(this),Event.observe(document,"mouseup",this.eventMouseUp),Event.observe(document,"mousemove",this.eventMouseMove),Event.observe(document,"keypress",this.eventKeypress)),this.drags.push(a)},unregister:function(a){this.drags=this.drags.reject(function(b){return b==a}),this.drags.length==0&&(Event.stopObserving(document,"mouseup",this.eventMouseUp),Event.stopObserving(document,"mousemove",this.eventMouseMove),Event.stopObserving(document,"keypress",this.eventKeypress))},activate:function(a){a.options.delay?this._timeout=setTimeout(function(){Draggables._timeout=null,window.focus(),Draggables.activeDraggable=a}.bind(this),a.options.delay):(window.focus(),this.activeDraggable=a)},deactivate:function(){this.activeDraggable=null},updateDrag:function(a){if(!this.activeDraggable)return;var b=[Event.pointerX(a),Event.pointerY(a)];if(this._lastPointer&&this._lastPointer.inspect()==b.inspect())return;this._lastPointer=b,this.activeDraggable.updateDrag(a,b)},endDrag:function(a){this._timeout&&(clearTimeout(this._timeout),this._timeout=null);if(!this.activeDraggable)return;this._lastPointer=null,this.activeDraggable.endDrag(a),this.activeDraggable=null},keyPress:function(a){this.activeDraggable&&this.activeDraggable.keyPress(a)},addObserver:function(a){this.observers.push(a),this._cacheObserverCallbacks()},removeObserver:function(a){this.observers=this.observers.reject(function(b){return b.element==a}),this._cacheObserverCallbacks()},notify:function(a,b,c){this[a+"Count"]>0&&this.observers.each(function(d){d[a]&&d[a](a,b,c)}),b.options[a]&&b.options[a](b,c)},_cacheObserverCallbacks:function(){["onStart","onEnd","onDrag"].each(function(a){Draggables[a+"Count"]=Draggables.observers.select(function(b){return b[a]}).length})}},Draggable=Class.create({initialize:function(a){var b={handle:!1,reverteffect:function(a,b,c){var d=Math.sqrt(Math.abs(b^2)+Math.abs(c^2))*.02;new Effect.Move(a,{x:-c,y:-b,duration:d,queue:{scope:"_draggable",position:"end"}})},endeffect:function(a){var b=Object.isNumber(a._opacity)?a._opacity:1;new Effect.Opacity(a,{duration:.2,from:.7,to:b,queue:{scope:"_draggable",position:"end"},afterFinish:function(){Draggable._dragging[a]=!1}})},zindex:1e3,revert:!1,quiet:!1,scroll:!1,scrollSensitivity:20,scrollSpeed:15,snap:!1,delay:0};(!arguments[1]||Object.isUndefined(arguments[1].endeffect))&&Object.extend(b,{starteffect:function(a){a._opacity=Element.getOpacity(a),Draggable._dragging[a]=!0,new Effect.Opacity(a,{duration:.2,from:a._opacity,to:.7})}});var c=Object.extend(b,arguments[1]||{});this.element=$(a),c.handle&&Object.isString(c.handle)&&(this.handle=this.element.down("."+c.handle,0)),this.handle||(this.handle=$(c.handle)),this.handle||(this.handle=this.element),c.scroll&&!c.scroll.scrollTo&&!c.scroll.outerHTML&&(c.scroll=$(c.scroll),this._isScrollChild=Element.childOf(this.element,c.scroll)),Element.makePositioned(this.element),this.options=c,this.dragging=!1,this.eventMouseDown=this.initDrag.bindAsEventListener(this),Event.observe(this.handle,"mousedown",this.eventMouseDown),Draggables.register(this)},destroy:function(){Event.stopObserving(this.handle,"mousedown",this.eventMouseDown),Draggables.unregister(this)},currentDelta:function(){return[parseInt(Element.getStyle(this.element,"left")||"0"),parseInt(Element.getStyle(this.element,"top")||"0")]},initDrag:function(a){if(!Object.isUndefined(Draggable._dragging[this.element])&&Draggable._dragging[this.element])return;if(Event.isLeftClick(a)){var b=Event.element(a);if(!(!(tag_name=b.tagName.toUpperCase())||tag_name!="INPUT"&&tag_name!="SELECT"&&tag_name!="OPTION"&&tag_name!="BUTTON"&&tag_name!="TEXTAREA"))return;var c=[Event.pointerX(a),Event.pointerY(a)],d=Position.cumulativeOffset(this.element);this.offset=[0,1].map(function(a){return c[a]-d[a]}),Draggables.activate(this),Event.stop(a)}},startDrag:function(a){this.dragging=!0,this.delta||(this.delta=this.currentDelta()),this.options.zindex&&(this.originalZ=parseInt(Element.getStyle(this.element,"z-index")||0),this.element.style.zIndex=this.options.zindex),this.options.ghosting&&(this._clone=this.element.cloneNode(!0),this._originallyAbsolute=this.element.getStyle("position")=="absolute",this._originallyAbsolute||Position.absolutize(this.element),this.element.parentNode.insertBefore(this._clone,this.element));if(this.options.scroll)if(this.options.scroll==window){var b=this._getWindowScroll(this.options.scroll);this.originalScrollLeft=b.left,this.originalScrollTop=b.top}else this.originalScrollLeft=this.options.scroll.scrollLeft,this.originalScrollTop=this.options.scroll.scrollTop;Draggables.notify("onStart",this,a),this.options.starteffect&&this.options.starteffect(this.element)},updateDrag:function(event,pointer){this.dragging||this.startDrag(event),this.options.quiet||(Position.prepare(),Droppables.show(pointer,this.element)),Draggables.notify("onDrag",this,event),this.draw(pointer),this.options.change&&this.options.change(this);if(this.options.scroll){this.stopScrolling();var p;if(this.options.scroll==window)with(this._getWindowScroll(this.options.scroll))p=[left,top,left+width,top+height];else p=Position.page(this.options.scroll),p[0]+=this.options.scroll.scrollLeft+Position.deltaX,p[1]+=this.options.scroll.scrollTop+Position.deltaY,p.push(p[0]+this.options.scroll.offsetWidth),p.push(p[1]+this.options.scroll.offsetHeight);var speed=[0,0];pointer[0]<p[0]+this.options.scrollSensitivity&&(speed[0]=pointer[0]-(p[0]+this.options.scrollSensitivity)),pointer[1]<p[1]+this.options.scrollSensitivity&&(speed[1]=pointer[1]-(p[1]+this.options.scrollSensitivity)),pointer[0]>p[2]-this.options.scrollSensitivity&&(speed[0]=pointer[0]-(p[2]-this.options.scrollSensitivity)),pointer[1]>p[3]-this.options.scrollSensitivity&&(speed[1]=pointer[1]-(p[3]-this.options.scrollSensitivity)),this.startScrolling(speed)}Prototype.Browser.WebKit&&window.scrollBy(0,0),Event.stop(event)},finishDrag:function(a,b){this.dragging=!1;if(this.options.quiet){Position.prepare();var c=[Event.pointerX(a),Event.pointerY(a)];Droppables.show(c,this.element)}this.options.ghosting&&(this._originallyAbsolute||Position.relativize(this.element),delete this._originallyAbsolute,Element.remove(this._clone),this._clone=null);var d=!1;b&&(d=Droppables.fire(a,this.element),d||(d=!1)),d&&this.options.onDropped&&this.options.onDropped(this.element),Draggables.notify("onEnd",this,a);var e=this.options.revert;e&&Object.isFunction(e)&&(e=e(this.element));var f=this.currentDelta();e&&this.options.reverteffect?(d==0||e!="failure")&&this.options.reverteffect(this.element,f[1]-this.delta[1],f[0]-this.delta[0]):this.delta=f,this.options.zindex&&(this.element.style.zIndex=this.originalZ),this.options.endeffect&&this.options.endeffect(this.element),Draggables.deactivate(this),Droppables.reset()},keyPress:function(a){if(a.keyCode!=Event.KEY_ESC)return;this.finishDrag(a,!1),Event.stop(a)},endDrag:function(a){if(!this.dragging)return;this.stopScrolling(),this.finishDrag(a,!0),Event.stop(a)},draw:function(a){var b=Position.cumulativeOffset(this.element);if(this.options.ghosting){var c=Position.realOffset(this.element);b[0]+=c[0]-Position.deltaX,b[1]+=c[1]-Position.deltaY}var d=this.currentDelta();b[0]-=d[0],b[1]-=d[1],this.options.scroll&&this.options.scroll!=window&&this._isScrollChild&&(b[0]-=this.options.scroll.scrollLeft-this.originalScrollLeft,b[1]-=this.options.scroll.scrollTop-this.originalScrollTop);var e=[0,1].map(function(c){return a[c]-b[c]-this.offset[c]}.bind(this));this.options.snap&&(Object.isFunction(this.options.snap)?e=this.options.snap(e[0],e[1],this):Object.isArray(this.options.snap)?e=e.map(function(a,b){return(a/this.options.snap[b]).round()*this.options.snap[b]}.bind(this)):e=e.map(function(a){return(a/this.options.snap).round()*this.options.snap}.bind(this)));var f=this.element.style;if(!this.options.constraint||this.options.constraint=="horizontal")f.left=e[0]+"px";if(!this.options.constraint||this.options.constraint=="vertical")f.top=e[1]+"px";f.visibility=="hidden"&&(f.visibility="")},stopScrolling:function(){this.scrollInterval&&(clearInterval(this.scrollInterval),this.scrollInterval=null,Draggables._lastScrollPointer=null)},startScrolling:function(a){if(!a[0]&&!a[1])return;this.scrollSpeed=[a[0]*this.options.scrollSpeed,a[1]*this.options.scrollSpeed],this.lastScrolled=new Date,this.scrollInterval=setInterval(this.scroll.bind(this),10)},scroll:function(){var current=new Date,delta=current-this.lastScrolled;this.lastScrolled=current;if(this.options.scroll==window)with(this._getWindowScroll(this.options.scroll))if(this.scrollSpeed[0]||this.scrollSpeed[1]){var d=delta/1e3;this.options.scroll.scrollTo(left+d*this.scrollSpeed[0],top+d*this.scrollSpeed[1])}else this.options.scroll.scrollLeft+=this.scrollSpeed[0]*delta/1e3,this.options.scroll.scrollTop+=this.scrollSpeed[1]*delta/1e3;Position.prepare(),Droppables.show(Draggables._lastPointer,this.element),Draggables.notify("onDrag",this),this._isScrollChild&&(Draggables._lastScrollPointer=Draggables._lastScrollPointer||$A(Draggables._lastPointer),Draggables._lastScrollPointer[0]+=this.scrollSpeed[0]*delta/1e3,Draggables._lastScrollPointer[1]+=this.scrollSpeed[1]*delta/1e3,Draggables._lastScrollPointer[0]<0&&(Draggables._lastScrollPointer[0]=0),Draggables._lastScrollPointer[1]<0&&(Draggables._lastScrollPointer[1]=0),this.draw(Draggables._lastScrollPointer)),this.options.change&&this.options.change(this)},_getWindowScroll:function(w){var T,L,W,H;with(w.document)w.document.documentElement&&documentElement.scrollTop?(T=documentElement.scrollTop,L=documentElement.scrollLeft):w.document.body&&(T=body.scrollTop,L=body.scrollLeft),w.innerWidth?(W=w.innerWidth,H=w.innerHeight):w.document.documentElement&&documentElement.clientWidth?(W=documentElement.clientWidth,H=documentElement.clientHeight):(W=body.offsetWidth,H=body.offsetHeight);return{top:T,left:L,width:W,height:H}}});Draggable._dragging={};var SortableObserver=Class.create({initialize:function(a,b){this.element=$(a),this.observer=b,this.lastValue=Sortable.serialize(this.element)},onStart:function(){this.lastValue=Sortable.serialize(this.element)},onEnd:function(){Sortable.unmark(),this.lastValue!=Sortable.serialize(this.element)&&this.observer(this.element)}}),Sortable={SERIALIZE_RULE:/^[^_\-](?:[A-Za-z0-9\-\_]*)[_](.*)$/,sortables:{},_findRootElement:function(a){while(a.tagName.toUpperCase()!="BODY"){if(a.id&&Sortable.sortables[a.id])return a;a=a.parentNode}},options:function(a){a=Sortable._findRootElement($(a));if(!a)return;return Sortable.sortables[a.id]},destroy:function(a){a=$(a);var b=Sortable.sortables[a.id];b&&(Draggables.removeObserver(b.element),b.droppables.each(function(a){Droppables.remove(a)}),b.draggables.invoke("destroy"),delete Sortable.sortables[b.element.id])},create:function(a){a=$(a);var b=Object.extend({element:a,tag:"li",dropOnEmpty:!1,tree:!1,treeTag:"ul",overlap:"vertical",constraint:"vertical",containment:a,handle:!1,only:!1,delay:0,hoverclass:null,ghosting:!1,quiet:!1,scroll:!1,scrollSensitivity:20,scrollSpeed:15,format:this.SERIALIZE_RULE,elements:!1,handles:!1,onChange:Prototype.emptyFunction,onUpdate:Prototype.emptyFunction},arguments[1]||{});this.destroy(a);var c={revert:!0,quiet:b.quiet,scroll:b.scroll,scrollSpeed:b.scrollSpeed,scrollSensitivity:b.scrollSensitivity,delay:b.delay,ghosting:b.ghosting,constraint:b.constraint,handle:b.handle};b.starteffect&&(c.starteffect=b.starteffect),b.reverteffect?c.reverteffect=b.reverteffect:b.ghosting&&(c.reverteffect=function(a){a.style.top=0,a.style.left=0}),b.endeffect&&(c.endeffect=b.endeffect),b.zindex&&(c.zindex=b.zindex);var d={overlap:b.overlap,containment:b.containment,tree:b.tree,hoverclass:b.hoverclass,onHover:Sortable.onHover},e={onHover:Sortable.onEmptyHover,overlap:b.overlap,containment:b.containment,hoverclass:b.hoverclass};Element.cleanWhitespace(a),b.draggables=[],b.droppables=[];if(b.dropOnEmpty||b.tree)Droppables.add(a,e),b.droppables.push(a);(b.elements||this.findElements(a,b)||[]).each(function(e,f){var g=b.handles?$(b.handles[f]):b.handle?$(e).select("."+b.handle)[0]:e;b.draggables.push(new Draggable(e,Object.extend(c,{handle:g}))),Droppables.add(e,d),b.tree&&(e.treeNode=a),b.droppables.push(e)}),b.tree&&(Sortable.findTreeElements(a,b)||[]).each(function(c){Droppables.add(c,e),c.treeNode=a,b.droppables.push(c)}),this.sortables[a.id]=b,Draggables.addObserver(new SortableObserver(a,b.onUpdate))},findElements:function(a,b){return Element.findChildren(a,b.only,b.tree?!0:!1,b.tag)},findTreeElements:function(a,b){return Element.findChildren(a,b.only,b.tree?!0:!1,b.treeTag)},onHover:function(a,b,c){if(Element.isParent(b,a))return;if(c>.33&&c<.66&&Sortable.options(b).tree)return;if(c>.5){Sortable.mark(b,"before");if(b.previousSibling!=a){var d=a.parentNode;a.style.visibility="hidden",b.parentNode.insertBefore(a,b),b.parentNode!=d&&Sortable.options(d).onChange(a),Sortable.options(b.parentNode).onChange(a)}}else{Sortable.mark(b,"after");var e=b.nextSibling||null;if(e!=a){var d=a.parentNode;a.style.visibility="hidden",b.parentNode.insertBefore(a,e),b.parentNode!=d&&Sortable.options(d).onChange(a),Sortable.options(b.parentNode).onChange(a)}}},onEmptyHover:function(a,b,c){var d=a.parentNode,e=Sortable.options(b);if(!Element.isParent(b,a)){var f,g=Sortable.findElements(b,{tag:e.tag,only:e.only}),h=null;if(g){var i=Element.offsetSize(b,e.overlap)*(1-c);for(f=0;f<g.length;f+=1){if(!(i-Element.offsetSize(g[f],e.overlap)>=0)){if(i-Element.offsetSize(g[f],e.overlap)/2>=0){h=f+1<g.length?g[f+1]:null;break}h=g[f];break}i-=Element.offsetSize(g[f],e.overlap)}}b.insertBefore(a,h),Sortable.options(d).onChange(a),e.onChange(a)}},unmark:function(){Sortable._marker&&Sortable._marker.hide()},mark:function(a,b){var c=Sortable.options(a.parentNode);if(c&&!c.ghosting)return;Sortable._marker||(Sortable._marker=($("dropmarker")||Element.extend(document.createElement("DIV"))).hide().addClassName("dropmarker").setStyle({position:"absolute"}),document.getElementsByTagName("body").item(0).appendChild(Sortable._marker));var d=Position.cumulativeOffset(a);Sortable._marker.setStyle({left:d[0]+"px",top:d[1]+"px"}),b=="after"&&(c.overlap=="horizontal"?Sortable._marker.setStyle({left:d[0]+a.clientWidth+"px"}):Sortable._marker.setStyle({top:d[1]+a.clientHeight+"px"})),Sortable._marker.show()},_tree:function(a,b,c){var d=Sortable.findElements(a,b)||[];for(var e=0;e<d.length;++e){var f=d[e].id.match(b.format);if(!f)continue;var g={id:encodeURIComponent(f?f[1]:null),element:a,parent:c,children:[],position:c.children.length,container:$(d[e]).down(b.treeTag)};g.container&&this._tree(g.container,b,g),c.children.push(g)}return c},tree:function(a){a=$(a);var b=this.options(a),c=Object.extend({tag:b.tag,treeTag:b.treeTag,only:b.only,name:a.id,format:b.format},arguments[1]||{}),d={id:null,parent:null,children:[],container:a,position:0};return Sortable._tree(a,c,d)},_constructIndex:function(a){var b="";do a.id&&(b="["+a.position+"]"+b);while((a=a.parent)!=null);return b},sequence:function(a){a=$(a);var b=Object.extend(this.options(a),arguments[1]||{});return $(this.findElements(a,b)||[]).map(function(a){return a.id.match(b.format)?a.id.match(b.format)[1]:""})},setSequence:function(a,b){a=$(a);var c=Object.extend(this.options(a),arguments[2]||{}),d={};this.findElements(a,c).each(function(a){a.id.match(c.format)&&(d[a.id.match(c.format)[1]]=[a,a.parentNode]),a.parentNode.removeChild(a)}),b.each(function(a){var b=d[a];b&&(b[1].appendChild(b[0]),delete d[a])})},serialize:function(a){a=$(a);var b=Object.extend(Sortable.options(a),arguments[1]||{}),c=encodeURIComponent(arguments[1]&&arguments[1].name?arguments[1].name:a.id);return b.tree?Sortable.tree(a,arguments[1]).children.map(function(a){return[c+Sortable._constructIndex(a)+"[id]="+encodeURIComponent(a.id)].concat(a.children.map(arguments.callee))}).flatten().join("&"):Sortable.sequence(a,arguments[1]).map(function(a){return c+"[]="+encodeURIComponent(a)}).join("&")}};Element.isParent=function(a,b){return!a.parentNode||a==b?!1:a.parentNode==b?!0:Element.isParent(a.parentNode,b)},Element.findChildren=function(a,b,c,d){if(!a.hasChildNodes())return null;d=d.toUpperCase(),b&&(b=[b].flatten());var e=[];return $A(a.childNodes).each(function(a){a.tagName&&a.tagName.toUpperCase()==d&&(!b||Element.classNames(a).detect(function(a){return b.include(a)}))&&e.push(a);if(c){var f=Element.findChildren(a,b,c,d);f&&e.push(f)}}),e.length>0?e.flatten():[]},Element.offsetSize=function(a,b){return a["offset"+(b=="vertical"||b=="height"?"Height":"Width")]};