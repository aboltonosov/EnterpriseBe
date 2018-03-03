﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Отчет.СостояниеВыполненияЗаказовНаПроизводство.Команда.СостояниеВыполненияЗаказов");
	
	Если ЗначениеЗаполнено(ПараметрКоманды) 
		И ПараметрКоманды.Количество() = 1 Тогда
		Заказ = ПараметрКоманды[0];
	Иначе
		Заказ = Неопределено;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СписокЗаказов", ПараметрКоманды);
	
	ОткрытьФорму("Отчет.СостояниеВыполненияЗаказовНаПроизводство.Форма", 
				ПараметрыФормы, 
				ПараметрыВыполненияКоманды.Источник, 
				Заказ, 
				ПараметрыВыполненияКоманды.Окно, 
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);
				
	Если ПараметрКоманды.Количество() <> 1 Тогда
		// Событие вызывается, чтобы в уже открытой форме обработать новые заказы
		Оповестить("СостояниеВыполненияЗаказовНаПроизводство", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти