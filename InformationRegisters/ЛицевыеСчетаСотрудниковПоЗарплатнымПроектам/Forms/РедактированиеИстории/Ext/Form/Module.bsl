﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СтруктураВедущихОбъектов", СтруктураОбъектовВладельцев);
	Если Не ЗначениеЗаполнено(СтруктураОбъектовВладельцев) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для Каждого ОбъектВладелец Из СтруктураОбъектовВладельцев Цикл
		ЭтаФорма[ОбъектВладелец.Ключ] = ОбъектВладелец.Значение;
	КонецЦикла;
	
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
	
	ЗаполнитьИспользованиеЭД();
	
	НаборЗаписей.Сортировать("Период");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(НаборЗаписей, "Период", "ПериодСтрокой");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Набор = РеквизитФормыВЗначение("НаборЗаписей");
	Если Не Набор.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Сообщения = ПолучитьСообщенияПользователю(Истина);
		Если Сообщения <> Неопределено Тогда
			Для каждого ПолученноеСообщение Из Сообщения Цикл
				ПолученноеСообщение.КлючДанных = Неопределено;
				ПолученноеСообщение.Сообщить();
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОбъектВладелец Из СтруктураОбъектовВладельцев Цикл
		Элемент.ТекущиеДанные[ОбъектВладелец.Ключ] = ОбъектВладелец.Значение;
	КонецЦикла;
	
	НовыйПериод = НачалоМесяца(ОбщегоНазначенияКлиент.ДатаСеанса());
	Если НаборЗаписей.Количество() > 1 Тогда
		ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
	Иначе
		ПоследнийПериод = '00010101000000';
	КонецЕсли; 
	Если НовыйПериод <= ПоследнийПериод Тогда
		НовыйПериод = КонецМесяца(ПоследнийПериод) + 1;
	КонецЕсли; 
	Элемент.ТекущиеДанные.Период = НовыйПериод;
	Элемент.ТекущиеДанные.ДокументОснование = Неопределено;
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Элемент.ТекущиеДанные, "Период", "ПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "НаборЗаписей.Период", , Отказ);
	Иначе
		НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
				СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "НаборЗаписей.Период", , Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	// Созданные документом запрещаем удалять.
	Если Элемент.ТекущиеДанные.ИспользоватьЭД И ЗначениеЗаполнено(Элемент.ТекущиеДанные.ДокументОснование) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.НаборЗаписей.ТекущиеДанные, "Период", "ПериодСтрокой", Направление, Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		РедактированиеПериодическихСведенийКлиент.ОповеститьОЗавершенииПоСтруктуре(ЭтаФорма, "ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам", СтруктураОбъектовВладельцев);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьИспользованиеЭД()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Набор", НаборЗаписей.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Набор.Период,
	|	Набор.Организация,
	|	Набор.ФизическоеЛицо,
	|	Набор.ЗарплатныйПроект,
	|	Набор.НомерЛицевогоСчета,
	|	Набор.ДокументОснование
	|ПОМЕСТИТЬ ВТНабор
	|ИЗ
	|	&Набор КАК Набор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Набор.Период,
	|	Набор.Организация,
	|	Набор.ФизическоеЛицо,
	|	Набор.ЗарплатныйПроект,
	|	Набор.НомерЛицевогоСчета,
	|	Набор.ДокументОснование,
	|	ЗарплатныеПроекты.ИспользоватьЭлектронныйДокументооборотСБанком КАК ИспользоватьЭД
	|ИЗ
	|	ВТНабор КАК Набор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО Набор.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка";
	
	НаборЗаписей.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти
