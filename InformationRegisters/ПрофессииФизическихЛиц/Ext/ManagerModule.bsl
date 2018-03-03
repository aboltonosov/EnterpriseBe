﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеПрофессийФизическогоЛица(ФизическоеЛицоСсылка) Экспорт
	
	Профессии = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПрофессииФизическихЛиц.Профессия
		|ИЗ
		|	РегистрСведений.ПрофессииФизическихЛиц КАК ПрофессииФизическихЛиц
		|ГДЕ
		|	ПрофессииФизическихЛиц.ФизическоеЛицо = &ФизическоеЛицоСсылка";
		
	Запрос.УстановитьПараметр("ФизическоеЛицоСсылка", ФизическоеЛицоСсылка);
	
	Возврат ПредставлениеПрофессийПоКоллекцииЗаписей(Запрос.Выполнить().Выгрузить());
	
КонецФункции

Функция ПредставлениеПрофессийПоКоллекцииЗаписей(НаборЗаписей) Экспорт
	
	ПредставлениеПрофессии = "";
	
	Для Каждого СтрокаПрофессии Из НаборЗаписей Цикл
		ПредставлениеПрофессии 	= 
			ПредставлениеПрофессии + ?(ПустаяСтрока(ПредставлениеПрофессии), "", ", ") 
			+ ?(ЗначениеЗаполнено(СтрокаПрофессии.Профессия), Строка(СтрокаПрофессии.Профессия), "");
	КонецЦикла;
	
	Если ПустаяСтрока(ПредставлениеПрофессии) Тогда
		ПредставлениеПрофессии = НСтр("ru = 'Не владеет профессиями'");
	КонецЕсли; 
	
	Возврат ПредставлениеПрофессии;
	
КонецФункции

#КонецОбласти

#КонецЕсли