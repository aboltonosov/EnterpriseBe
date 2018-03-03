﻿// 4D:ERP для Беларуси
// {
// Форма изменена
// }
// 4D
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхФизическихЛицЗарплатаКадры") Тогда
		
		ТолькоПросмотр = Истина;
		
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
			
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
		
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), ЗаписьНабора);
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			
			Элемент.ТекущиеДанные.ФизЛицо = ОбъектВладелец;
			Если НаборЗаписей.Количество() > 1 Тогда
				ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
				Элемент.ТекущиеДанные.Период = КонецДня(ПоследнийПериод) + 1;
			КонецЕсли; 
			Элемент.ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ");
			Элемент.ТекущиеДанные.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НЕ ОтменаРедактирования Тогда
		Если Элемент.ТекущиеДанные <> Неопределено Тогда
			ИндексТекущейСтроки = НаборЗаписей.Индекс(Элемент.ТекущиеДанные);
			Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].Период", , Отказ);
			ИначеЕсли НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ВидДокумента) Тогда
				СообщениеОбОшибке = НСтр("ru = 'Необходимо указать вид документа'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].ВидДокумента", , Отказ);
			Иначе
				НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период,ЯвляетсяДокументомУдостоверяющимЛичность", Элемент.ТекущиеДанные.Период, Истина));
				Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
						СообщениеОбОшибке = НСтр("ru = 'Уже есть запись о документе, являющемся удостоверении личности с указанной датой сведений'");
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке,,"НаборЗаписей[" + ИндексТекущейСтроки + "].Период", , Отказ);
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НаборЗаписей.Количество() = 1 
		И НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
		Элемент.ТекущиеДанные.Период = Элемент.ТекущиеДанные.ДатаВыдачи;
	КонецЕсли;
	
	Элементы.НаборЗаписей.ОтборСтрок = Неопределено;
	НаборЗаписей.Сортировать("Период,ЯвляетсяДокументомУдостоверяющимЛичность");
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ЯвляетсяДокументомУдостоверяющимЛичность", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейДатаВыдачиПриИзменении(Элемент)
	ИдентификаторТекущейСтроки = Элементы.НаборЗаписей.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Период) И ЗначениеЗаполнено(ТекущаяСтрока.ДатаВыдачи) Тогда
				ТекущаяСтрока.Период = ТекущаяСтрока.ДатаВыдачи;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершении(ЭтаФорма, "ДокументыФизическихЛиц", ОбъектВладелец);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти
