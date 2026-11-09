class_name MerchantSlot extends Control
var slotNum: int = -1
@export var ShopButton: MerchantButton

#func purchaseCard()->CardBase:
	#if Global.gold >= ShopButton.card.data.stats["Value"]:
		#
		#var purchasedCard = ShopButton.card
		#
		#ShopButton.removeCard()
		#ShopButton.cardIsSold = true
		#Global.gold -= purchasedCard.data.stats["Value"]
		#
		#print("Purchased the card: ", purchasedCard.name)
		#return purchasedCard
	#else:
		#pass
		##purchase failed denyPurchase() animation?
	#return null
#
#func _on_card_purchased() -> void:
	#purchaseCard()
#
#func addToShopSlot(newCard:CardBase)->void:
	#ShopButton.setCard(newCard)
