﻿

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Документ.ОтчетКомиссионера.Форма.ФормаСпискаСамообслуживание",
				,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность,
				ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

