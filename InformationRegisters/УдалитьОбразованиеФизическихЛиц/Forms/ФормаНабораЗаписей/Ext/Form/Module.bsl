﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Параметры.Отбор.Свойство("ФизическоеЛицо", ФизическоеЛицоСсылка);
	
	СотрудникиФормыРасширенный.ПрочитатьНаборЗаписей(ЭтаФорма, "ОбразованиеФизическихЛиц");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПредставлениеСведенийОбОбразовании = 
		РегистрыСведений.УдалитьОбразованиеФизическихЛиц.ПредставлениеСведенийОбОбразованииПоКоллекцииЗаписей(ОбразованиеФизическихЛиц);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("ИзмененоОбразованиеФизическихЛиц", ПредставлениеСведенийОбОбразовании, ВладелецФормы);
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.ФизическоеЛицо = ФизическоеЛицоСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
