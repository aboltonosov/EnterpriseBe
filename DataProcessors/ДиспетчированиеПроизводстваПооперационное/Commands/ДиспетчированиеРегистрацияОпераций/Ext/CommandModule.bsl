﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МетодикаУправления = ПредопределенноеЗначение("Перечисление.УправлениеМаршрутнымиЛистами.РегистрацияОпераций");
	ОперативныйУчетПроизводстваКлиент.ОткрытьФормуДиспетчированиеПооперационное(МетодикаУправления);
	
КонецПроцедуры

#КонецОбласти