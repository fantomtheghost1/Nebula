extends Node3D

signal BackPressed

var starbase_credits : int = 100000
var starbase_warehouse_container : Node3D
var targeted_item : Resource
var buying : bool = false

func SellItemToStarbase(item : Resource, quantity : int, seller : Captain):
	if starbase_credits - (quantity * item.value) >= 0:
		starbase_warehouse_container.GetWarehouseFromID(0).AddCargo(item, quantity)
		starbase_warehouse_container.GetWarehouseFromCaptain(seller).SubtractCargo(item, quantity)
		seller.AddCredits(quantity * item.value)
		starbase_credits -= (quantity * item.value)
		print("trade complete!")
		ClearTradeButtons()
		PopulateTradeList()
	else:
		print("the starbase cannot afford this trade...")
		
func BuyItemFromStarbase(item : Resource, quantity : int, buyer : Captain):
	if buyer.GetCredits() - (quantity * item.value) >= 0:
		starbase_warehouse_container.GetWarehouseFromCaptain(buyer).AddCargo(item, quantity)
		starbase_warehouse_container.GetWarehouseFromID(0).SubtractCargo(item, quantity)
		buyer.SubtractCredits(quantity * item.value)
		starbase_credits += (quantity * item.value)
		print("trade complete!")
		ClearTradeButtons()
		PopulateTradeList()
	else:
		print("the client cannot afford this trade...")
	
func TradePressed() -> void:
	%TradeUI.visible = true
	ClearTradeButtons()
	PopulateTradeList()
	
func PopulateTradeList() -> void:
	if !buying:
		var items = starbase_warehouse_container.GetWarehouseFromCaptain(SteamManager.client).GetDifferentItemsInWarehouse()
		if !(targeted_item in items):
			%SellMenu.visible = false
		print(items)
		for item in items:
			print(item.name)
			var max_quantity = starbase_warehouse_container.GetWarehouseFromCaptain(SteamManager.client).GetQuantityFromID(item.id)
			var button = Button.new()
			%TradeButtonContainer.add_child(button)
			%QuantitySlider.max_value = float(max_quantity)
			button.text = item.name + " : " + str(max_quantity)
			button.pressed.connect(ShowTrade.bind(item, max_quantity))
			
	else:
		var items = starbase_warehouse_container.GetWarehouseFromID(0).GetDifferentItemsInWarehouse()
		if !(targeted_item in items):
			%SellMenu.visible = false
		print(items)
		for item in items:
			print(item.name)
			var max_quantity = starbase_warehouse_container.GetWarehouseFromID(0).GetQuantityFromID(item.id)
			var button = Button.new()
			%TradeButtonContainer.add_child(button)
			%QuantitySlider.max_value = float(max_quantity)
			button.text = item.name + " : " + str(max_quantity)
			button.pressed.connect(ShowTrade.bind(item, max_quantity))
		
func ShowTrade(item : Resource, max_quantity : int):
	%SellMenu.visible = true
	%Material.text = item.name
	targeted_item = item
	%SellValue.text = "Credits:\n" + str(targeted_item.value * int(%QuantitySlider.value))
	
func ClearTradeButtons():
	for button in %TradeButtonContainer.get_children():
		button.queue_free()

func _on_back_pressed() -> void:
	BackPressed.emit()
	%TradeUI.visible = false
	%SellMenu.visible = false
	ClearTradeButtons()

func _on_quantity_slider_value_changed(value: float) -> void:
	%SellValue.text = "Credits:\n" + str(targeted_item.value * int(%QuantitySlider.value))
	%QuantityManual.placeholder_text = str(int(%QuantitySlider.value))

func _on_quantity_manual_text_changed(new_text: String) -> void:
	%SellValue.text = "Credits:\n" + str(targeted_item.value * int(new_text))
	%QuantitySlider.value = float(new_text)

func _on_trade_mode_pressed() -> void:
	if buying:
		buying = false
		%TradeMode.text = "Selling to Starbase"
		%BuySell.text = "Sell"
	else:
		buying = true
		%TradeMode.text = "Buying from Starbase"
		%BuySell.text = "Buy"
		#%BuySell.pressed.connect(ShowTrade.bind(item, max_quantity))
		
	ClearTradeButtons()
	PopulateTradeList()

func _on_buy_sell_pressed() -> void:
	if !buying:
		SellItemToStarbase(targeted_item, int(%QuantitySlider.value), SteamManager.client)
	if buying:
		BuyItemFromStarbase(targeted_item, int(%QuantitySlider.value), SteamManager.client)
