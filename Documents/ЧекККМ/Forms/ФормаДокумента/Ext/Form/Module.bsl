﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Объект.Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
		Элементы.ГруппаСуммаСдачи.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЧекККМ));
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий); 
		УстановитьВидимостьЭлементовСерий();
		ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
		Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
		
	КонецЕсли;
	
	ИспользоватьАкцизныеМарки = ИнтеграцияЕГАИСВызовСервера.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(
		Объект.Организация, Объект.Склад, Объект.Дата);
	Элементы.ТоварыНоменклатураЕГАИС.Видимость = ИспользоватьАкцизныеМарки;
	
	Элементы.ТоварыПомещение.Видимость = СкладыСервер.ИспользоватьСкладскиеПомещения(Объект.Склад,Объект.Дата);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПересчитатьДокументНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ЧекККМ));
	УстановитьВидимостьЭлементовСерий();
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НаборыКлиент.БлокируемыйЭлемент(Поле) Тогда
		
		ТекущаяСтрока = Объект.Товары.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ЗначениеЗаполнено(ТекущаяСтрока.НоменклатураНабора) Тогда
			
			ПараметрОповещения = Новый Структура;
			ПараметрОповещения.Вставить("НоменклатураНабора",   ТекущаяСтрока.НоменклатураНабора);
			ПараметрОповещения.Вставить("ХарактеристикаНабора", ТекущаяСтрока.ХарактеристикаНабора);
			ПараметрОповещения.Вставить("ФормаВладелец", УникальныйИдентификатор);
			
			Оповестить("РедактироватьНабор", ПараметрОповещения, ЭтаФорма);
			
		КонецЕсли;
		
	ИначеЕсли Поле = Элементы.ТоварыНоменклатураНабора Тогда
		ПоказатьЗначение(Неопределено, Элементы.Товары.ТекущиеДанные.НоменклатураНабора);
	ИначеЕсли Поле = Элементы.ТоварыСтатусУказанияСерий
		Или Поле = Элементы.ТоварыСерия Тогда
		
		ОткрытьПодборСерий();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если Не ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, Ложь);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(ЭтаФорма, Ложь);

	//

	НаборыСервер.УстановитьУсловноеОформление(ЭтаФорма, "Товары");

КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#Область Наборы

&НаКлиенте
// Вызывается через ОписаниеОповещения из общего модуля НаборыКлиент 
Процедура ПриУдаленииКомплектующих(Действие, ДополнительныйПараметр) Экспорт
	
	Если НаборыКлиент.ДействиеРедактироватьНабор(Действие) Тогда
		НаборыКлиент.ПриУдаленииКомплектующих(ЭтаФорма, "Товары", ДополнительныйПараметр);
	ИначеЕсли НаборыКлиент.ДействиеУдалитьВесьНабор(Действие) Тогда
		ПриУдаленииКомплектующихНаСервере("Товары", ДополнительныйПараметр);
	КонецЕсли;
	
	ПересчитатьДокументНаКлиенте();
	
КонецПроцедуры

&НаСервере
Процедура ПриУдаленииКомплектующихНаСервере(ИмяТЧ, ДополнительныйПараметр)
	НаборыСервер.ПриУдаленииКомплектующих(ЭтаФорма, ИмяТЧ, ДополнительныйПараметр);
КонецПроцедуры

&НаСервере
Функция АдресНабораВоВременномХранилище(Параметры) Экспорт
	
	Возврат НаборыСервер.АдресНабораВоВременномХранилище(ЭтаФорма, Параметры, "Товары");
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура ПересчитатьДокументНаКлиенте()
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Объект.Товары, Объект.ЦенаВключаетНДС);
	ОплаченоПрочее = Объект.ОплатаПлатежнымиКартами.Итог("Сумма") + Объект.ПодарочныеСертификаты.Итог("Сумма");
	СуммаСдачи = Объект.ОплатаПлатежнымиКартами.Итог("Сумма") + Объект.ПодарочныеСертификаты.Итог("Сумма") + Объект.ПолученоНаличными - Объект.СуммаДокумента;
	СуммаСкидки = Объект.Товары.Итог("СуммаРучнойСкидки") + Объект.Товары.Итог("СуммаАвтоматическойСкидки");
	СуммаБезСкидки = Объект.СуммаДокумента + СуммаСкидки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.ТоварыСтатусУказанияСерий.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.ТоварыСерия.Видимость = ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям;
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, ПараметрыЗаполненияРеквизитов);
	
	НаборыСервер.ЗаполнитьСлужебныеРеквизиты(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий()
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,"",ТекущиеДанные)Тогда
		ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();

		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		
		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

#КонецОбласти

#КонецОбласти
