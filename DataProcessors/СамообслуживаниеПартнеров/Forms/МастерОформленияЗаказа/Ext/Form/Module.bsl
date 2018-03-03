﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Партнер") Тогда
		Партнер = Параметры.Партнер;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Соглашение") Тогда
		Соглашение = Параметры.Соглашение;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	СоглашениеСКлиентом.Наименование КАК СоглашениеСтрока,
		|	СоглашениеСКлиентом.ГрафикОплаты,
		|	ЕСТЬNULL(ГрафикиОплаты.ФормаОплаты, СоглашениеСКлиентом.ФормаОплаты) КАК ФормаОплаты,
		|	СоглашениеСКлиентом.Валюта,
		|	СоглашениеСКлиентом.ЦенаВключаетНДС,
		|	СоглашениеСКлиентом.Контрагент,
		|	СоглашениеСКлиентом.Организация,
		|	СоглашениеСКлиентом.НалогообложениеНДС,
		|	СоглашениеСКлиентом.Склад,
		|	СоглашениеСКлиентом.ХозяйственнаяОперация,
		|	СоглашениеСКлиентом.ИспользуютсяДоговорыКонтрагентов,
		|	СоглашениеСКлиентом.КонтактноеЛицо,
		|	СоглашениеСКлиентом.ПорядокРасчетов,
		|	&Партнер КАК Партнер
		|ИЗ
		|	Справочник.СоглашенияСКлиентами КАК СоглашениеСКлиентом
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГрафикиОплаты КАК ГрафикиОплаты
		|		ПО СоглашениеСКлиентом.ГрафикОплаты = ГрафикиОплаты.Ссылка
		|ГДЕ
		|	СоглашениеСКлиентом.Ссылка = &Соглашение";
		
		Запрос.УстановитьПараметр("Соглашение", Соглашение);
		Запрос.УстановитьПараметр("Партнер", Партнер);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ЭтаФорма,Выборка);
			Если Не ЗначениеЗаполнено(НалогообложениеНДС) ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
				НалогообложениеНДС = ЗначениеНастроекПовтИсп.ПолучитьНалогообложениеНДС(Выборка.Организация, , ТекущаяДатаСеанса());
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.Свойство("КонтактноеЛицо") Тогда
		КонтактноеЛицо = Параметры.КонтактноеЛицо;
		Если Параметры.Свойство("АвторизованПартнер") И Не Параметры.АвторизованПартнер Тогда
			ОбъектАвторизации = КонтактноеЛицо;
		Иначе
			ОбъектАвторизации = Партнер;
		КонецЕсли;
	Иначе
		ОбъектАвторизации = Партнер;
	КонецЕсли;
	
	ИспользоватьПартнеровКакКонтрагентов = ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов");
	
	Если Параметры.Свойство("Склад") Тогда
		Склад = Параметры.Склад;
		СкладЯвляетсяГруппойСкладов = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Склад, "ЭтоГруппа");
	КонецЕсли;
	
	Если Параметры.Свойство("АдресКорзины") Тогда
		СформироватьТаблицуТоварыПоДаннымКорзины(Параметры.АдресКорзины);
	КонецЕсли;
	
	ВариантОформленияЗаказа = 1;
	
	МакетИтоговаяИнформация = Обработки.СамообслуживаниеПартнеров.ПолучитьМакет("ОформлениеЗаказа").ПолучитьТекст();
	СамообслуживаниеСервер.УстановитьЦветФонаИнформацииНTML(МакетИтоговаяИнформация);
	
	Если Не ЗначениеЗаполнено(КонтактноеЛицо) Тогда
		КонтактноеЛицо = ПартнерыИКонтрагенты.ПолучитьКонтактноеЛицоПартнераПоУмолчанию(Партнер);
	КонецЕсли;
	
	ИспользоватьУправлениеДоставкой = ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой");
	СпособДоставки = Перечисления.СпособыДоставки.Самовывоз;
	ДоставкаТоваров.УстановитьДоступностьАдресовДоставки(ЭтаФорма.Элементы);
	ДоставкаТоваров.ЗаполнитьСпискиВыбораАдресовПолучателяОтправителя(ЭтаФорма.Элементы,
		Новый Структура("Партнер,Ссылка", Партнер, Документы.РеализацияТоваровУслуг.ПустаяСсылка()));
	ЗаполнитьУстановитьРеквизитыДоставкиСервер("Партнер");
	
	УправлениеДоступностьюСервер(Выборка);
	
	ПродажиСервер.ЗаполнитьСписокВыбораАдреса(Элементы.АдресДоставки, Партнер);
	
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВремяДоставкиС);
	ДоставкаТоваровКлиентСервер.ЗаполнитьСписокВыбораПоляВремени(Элементы.ВремяДоставкиПо);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		КонтрагентПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелаемаяДатаОтгрузкиПриИзменении(Элемент)
	
	ТекущаяДатаСеанса = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если ЗначениеЗаполнено(ЖелаемаяДатаОтгрузки) И ЖелаемаяДатаОтгрузки < НачалоДня(ТекущаяДатаСеанса) Тогда
		ЖелаемаяДатаОтгрузки = НачалоДня(ТекущаяДатаСеанса);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобранныеТоварыРассчитанныеСкидкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОтобранныеТоварыРассчитанныеСкидкиНоменклатура" 
		ИЛИ Поле.Имя = "ОтобранныеТоварыРассчитанныеСкидкиХарактеристика" Тогда
		
		ОткрытьКарточкуНоменклатуры();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СпособДоставкиПриИзменении(Элемент)
	
	Если СпособДоставки = ПредопределенноеЗначение("Перечисление.СпособыДоставки.Самовывоз") Тогда
		ДоставкаТоваровКлиентСервер.УстановитьСтраницуДоставки(Элементы,СпособДоставки)
	Иначе
		ЗаполнитьУстановитьРеквизитыДоставкиСервер(Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиПриИзменении(Элемент)
	
	ИмяРеквизитаАдресаДоставки = "АдресДоставки";
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		ЭтаФорма[ИмяРеквизитаАдресаДоставки],
		ЭтаФорма[ИмяРеквизитаАдресаДоставки + "ЗначенияПолей"]);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОчистка(Элемент, СтандартнаяОбработка)
	
	АдресДоставкиПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИмяРеквизитаАдресаДоставки = "АдресДоставки";
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
		Элемент,
		ЭтаФорма,
		ИмяРеквизитаАдресаДоставки,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресДоставкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	АдресДоставкиПриИзменении(Элемент);
	
	РеквизитыДоставки = ДоставкаТоваровКлиентСервер.ПолучитьПустуюСтруктуруРеквизитовДоставки();
	ЗаполнитьЗначенияСвойств(РеквизитыДоставки, ЭтаФорма);
	ДоставкаТоваровКлиент.АдресДоставкиОбработкаВыбора(Элементы, РеквизитыДоставки, Элемент.Имя, ВыбранноеЗначение);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РеквизитыДоставки);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	ВыполнитьПереходПоСтраницам(Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьИнформациюОСкидках(Команда)
	
	ТекущиеДанные = Элементы.ОтобранныеТоварыРассчитанныеСкидки.ТекущиеДанные;
	СкидкиНаценкиКлиент.ОткрытьФормуПримененныеСкидки(ТекущиеДанные, ЗаполнитьСтруктуруПоРеквизитамФормы(), ЭтаФорма,
	                                                  СамообслуживаниеКлиент.ДополнительныеПараметрыПримененныеСкидки());
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуТовара(Команда)
	
	ОткрытьКарточкуНоменклатуры();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//Приоритет
	
	ОбщегоНазначенияУТ.УстановитьУсловноеОформлениеПриоритета(ЭтотОбъект);
	
	//Упаковка

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтобранныеТоварыРассчитанныеСкидкиЕдИзм.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтобранныеТоварыРассчитанныеСкидки.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//Характеристика

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтобранныеТоварыРассчитанныеСкидкиХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОтобранныеТоварыРассчитанныеСкидки.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтмененнойСтрокиДокумента);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<характеристики не используются>'"));
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСтруктуруПоРеквизитамФормы()
	
	СтруктураДляРасчетаСкидок = Новый Структура;
	
	СтруктураДляРасчетаСкидок.Вставить("Ссылка",Документы.ЗаказКлиента.ПустаяСсылка());
	СтруктураДляРасчетаСкидок.Вставить("Дата",ТекущаяДатаСеанса());
	СтруктураДляРасчетаСкидок.Вставить("Соглашение",Соглашение);
	СтруктураДляРасчетаСкидок.Вставить("Склад",Склад);
	СтруктураДляРасчетаСкидок.Вставить("КартаЛояльности",Справочники.КартыЛояльности.ПустаяСсылка());
	СтруктураДляРасчетаСкидок.Вставить("Партнер",Партнер);
	СтруктураДляРасчетаСкидок.Вставить("ГрафикОплаты",ГрафикОплаты);
	СтруктураДляРасчетаСкидок.Вставить("ФормаОплаты",ФормаОплаты);
	СтруктураДляРасчетаСкидок.Вставить("Валюта",Валюта);
	СтруктураДляРасчетаСкидок.Вставить("Контрагент",Контрагент);
	СтруктураДляРасчетаСкидок.Вставить("КонтактноеЛицо", КонтактноеЛицо);
	СтруктураДляРасчетаСкидок.Вставить("Менеджер",Неопределено);
	СтруктураДляРасчетаСкидок.Вставить("Организация",Организация);
	СтруктураДляРасчетаСкидок.Вставить("НалогообложениеНДС",НалогообложениеНДС);
	СтруктураДляРасчетаСкидок.Вставить("ЦенаВключаетНДС",ЦенаВключаетНДС);
	СтруктураДляРасчетаСкидок.Вставить("СуммаДокумента",СуммаДокумента);
	СтруктураДляРасчетаСкидок.Вставить("СкидкиРассчитаны",Ложь);
	СтруктураДляРасчетаСкидок.Вставить("ЖелаемаяДатаОтгрузки",ЖелаемаяДатаОтгрузки);
	СтруктураДляРасчетаСкидок.Вставить("ДополнительнаяИнформация",ДополнительнаяИнформация);
	СтруктураДляРасчетаСкидок.Вставить("ХозяйственнаяОперация",ХозяйственнаяОперация);
	СтруктураДляРасчетаСкидок.Вставить("СпособДоставки",СпособДоставки);
	СтруктураДляРасчетаСкидок.Вставить("ВремяДоставкиС",ВремяДоставкиС);
	СтруктураДляРасчетаСкидок.Вставить("ВремяДоставкиПо",ВремяДоставкиПо);
	СтруктураДляРасчетаСкидок.Вставить("ДополнительнаяИнформацияПоДоставке",ДополнительнаяИнформацияПоДоставке);
	СтруктураДляРасчетаСкидок.Вставить("ЗонаДоставки",ЗонаДоставки);
	СтруктураДляРасчетаСкидок.Вставить("АдресДоставкиЗначенияПолей",АдресДоставкиЗначенияПолей);
	СтруктураДляРасчетаСкидок.Вставить("ПеревозчикПартнер",ПеревозчикПартнер);
	СтруктураДляРасчетаСкидок.Вставить("АдресДоставки",АдресДоставки);
	СтруктураДляРасчетаСкидок.Вставить("НеОтгружатьЧастями",НеОтгружатьЧастями);
	СтруктураДляРасчетаСкидок.Вставить("ВернутьМногооборотнуюТару",Ложь);
	Если ИспользуютсяДоговорыКонтрагентов Тогда
		СтруктураДляРасчетаСкидок.Вставить("Договор",Договор);
	КонецЕсли;
	
	СтруктураДляРасчетаСкидок.Вставить("Товары",ОтобранныеТоварыРассчитанныеСкидки);
	СтруктураДляРасчетаСкидок.Вставить("СкидкиНаценки",СкидкиНаценки);
	СтруктураДляРасчетаСкидок.Вставить("ЭтапыГрафикаОплаты",ЭтапыГрафикаОплаты);
	СтруктураДляРасчетаСкидок.Вставить("ОбъектАвторизации", ОбъектАвторизации);
	СтруктураДляРасчетаСкидок.Вставить("Приоритет", Приоритет);
	Возврат СтруктураДляРасчетаСкидок;
	
КонецФункции

&НаСервере
Процедура РассчитатьСкидки()
	
	СтруктураДляРасчетаСкидок = ЗаполнитьСтруктуруПоРеквизитамФормы();
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("ПрименятьКОбъекту",                Истина);
	СтруктураПараметры.Вставить("ТолькоПредварительныйРасчет",      Ложь);
	СтруктураПараметры.Вставить("ВосстанавливатьУправляемыеСкидки", Ложь);
	СтруктураПараметры.Вставить("УправляемыеСкидки", Новый Массив);
	
	ПримененныеСкидки = СкидкиНаценкиСервер.Рассчитать(СтруктураДляРасчетаСкидок,СтруктураПараметры);
	АдресПримененныхСкидокВоВременномХранилище = ПоместитьВоВременноеХранилище(ПримененныеСкидки,УникальныйИдентификатор);
	СуммаДокумента = СтруктураДляРасчетаСкидок.СуммаДокумента;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюСервер(Данные)
	
	Элементы.ФормаОплаты.ТолькоПросмотр = ЗначениеЗаполнено(ФормаОплаты);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиВПродажах") Тогда
		Элементы.ГруппаТоварыСкидкиНаценки.Видимость = Ложь;
		Элементы.ДекорацияТовары.Заголовок = НСтр("ru = 'Проверьте отобранные для оформления заказа товары'");
	КонецЕсли;
	
	СамообслуживаниеСервер.УправлениеЭлементомФормыКонтрагент(ЭтаФорма, Данные, Элементы.Контрагент);
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(ЭтаФорма, Элементы.Договор, ИспользуютсяДоговорыКонтрагентов);
	
	Элементы.АдресДоставки.Видимость                           = НЕ ИспользоватьУправлениеДоставкой;
	Элементы.АдресДоставкиПолучателя.Видимость                 = ИспользоватьУправлениеДоставкой;
	Элементы.ГруппаДоставка.Видимость                          = ИспользоватьУправлениеДоставкой;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИтоговуюИнформацию()
	
	ИтоговаяИнформация = МакетИтоговаяИнформация;
	
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#Соглашение#",СоглашениеСтрока);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#Склад#",Склад);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#ГрафикОплаты#",ГрафикОплаты);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#ФормаОплаты#",ФормаОплаты);
	Если НЕ ИспользоватьПартнеровКакКонтрагентов Тогда
		ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#Контрагент#",Контрагент);
		ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#КТ#","");
	Иначе
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ИтоговаяИнформация,"#КТ#");
	КонецЕсли;
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#Приоритет#", Приоритет);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#КонтактноеЛицо#", КонтактноеЛицо);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#НалогообложениеНДС#",НалогообложениеНДС);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#АдресДоставки#",АдресДоставки);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#ЖелаемаяДатаОтгрузки#",Формат(ЖелаемаяДатаОтгрузки,"ДЛФ=D")); 
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#НеОтгружатьЧастями#",
	                                ?(НеОтгружатьЧастями,Нстр("ru='Не отгружать частями'"),Нстр("ru='Возможна отгрузка частями'")));
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#КоличествоПозиций#",Строка(ОтобранныеТоварыРассчитанныеСкидки.Количество()));
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#СуммаДокумента#",Формат(СуммаДокумента,"ЧДЦ=2"));
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#Валюта#",Валюта);
	Если ИспользоватьУправлениеДоставкой Тогда
		РеквизитыДоставки = НСтр("ru='Способ доставки'") + ": <EM>" + СпособДоставки + "</EM>" 
			+ "<BR>" + НСтр("ru='Желаемое время доставки'") +": <EM>"
			+ ?(ЗначениеЗаполнено(ВремяДоставкиС), НСтр("ru='c'") + " " + Формат(ВремяДоставкиС,"ДЛФ=T") + " ","")
			+ ?(ЗначениеЗаполнено(ВремяДоставкиПо),НСтр("ru='до'") + " " + Формат(ВремяДоставкиПо,"ДЛФ=T"),"")
			+ "</EM>" + "<BR>";
	Иначе
		РеквизитыДоставки = "";
	КонецЕсли;
	ИтоговаяИнформация  = СтрЗаменить(ИтоговаяИнформация,"#РеквизитыДоставки#",РеквизитыДоставки);
	
	СтрокаЭтапыГрафикаОплаты = "";
	
	Если ЭтапыГрафикаОплаты.Количество() = 0 Тогда
		ОбщегоНазначенияУТКлиентСервер.УдалитьИзСтрокиПодстроку(ИтоговаяИнформация,"#ГО#")
	Иначе
		Для каждого Строка Из ЭтапыГрафикаОплаты Цикл
			
			СтрокаЭтапыГрафикаОплаты = СтрокаЭтапыГрафикаОплаты +  Формат(Строка.ДатаПлатежа,"ДЛФ=D") 
			                           + " - " + Строка.ВариантОплаты + ": "
			                           + Формат(Строка.СуммаПлатежа,"ЧДЦ=2") + " "
			                           + Строка(Валюта)+ " (" + Строка.ПроцентПлатежа 
			                           + " "  +  Нстр("ru='% от суммы заказа)'") + " " + "<br>";
			
		КонецЦикла;
		ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#ГО#","");	
	КонецЕсли;
	
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация,"#ЭтапГрафикаОплаты#",СтрокаЭтапыГрафикаОплаты);
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	СамообслуживаниеСервер.УправлениеЭлементомФормыДоговор(ЭтаФорма, Элементы.Договор, ИспользуютсяДоговорыКонтрагентов);
	
КонецПроцедуры 

&НаКлиенте
Функция НеВыполненыУсловияПереходаПоСтраницам(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаДополнительныеРеквизиты Тогда
		Если Команда.Имя = "Далее" Тогда
			
			Если НЕ ЗначениеЗаполнено(ФормаОплаты) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru='Не указана форма оплаты.'"),,"ФормаОплаты");
				Отказ = Истина;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru='Не указан контрагент.'"),,"Контрагент");
				Отказ = Истина;
			КонецЕсли;
			
			Если ИспользуютсяДоговорыКонтрагентов И НЕ ЗначениеЗаполнено(Договор) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru='Не указан договор.'"),,"Договор");
				Отказ = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаТовары Тогда	 
		
		Если ОтобранныеТоварыРассчитанныеСкидки.Количество() = 0 Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru='Нет товаров для оформления заказа.'")
			                                                  ,,"ОтобранныеТоварыРассчитанныеСкидки");
			Отказ = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПереходПоСтраницам(Команда)
	
	Если НеВыполненыУсловияПереходаПоСтраницам(Команда) Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаДополнительныеРеквизиты Тогда
		Если Команда.Имя = "Далее" Тогда
			
			Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаТовары;
			Элементы.СтраницыКнопки.ТекущаяСтраница   = Элементы.СтраницаКнопкиНазадДалееОтмена;
			Элементы.КнопкаДалееСтраницаНазадДалееОтмена.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаТовары Тогда
		
		Если Команда.Имя = "Назад" Тогда
			
			Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаДополнительныеРеквизиты;
			Элементы.СтраницыКнопки.ТекущаяСтраница   = Элементы.СтраницаКнопкиДалееОтмена;
			Элементы.КнопкаДалееСтраницаДалееОтмена.КнопкаПоУмолчанию = Истина;
			
		ИначеЕсли Команда.Имя = "Далее" Тогда
			
			ЗаполнитьИтоговуюИнформацию();
			Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаИтоговаяИнформация;
			Элементы.СтраницыКнопки.ТекущаяСтраница   = Элементы.СтраницаКнопкиОтменаНазадОформить;
			Элементы.КнопкаОформить.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	ИначеЕсли Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаИтоговаяИнформация Тогда
		
		Если Команда.Имя = "Далее" Тогда
			
			ОформитьЗаказ();
			Оповестить("Запись_ЗаказКлиента", Новый Структура("ОбъектАвторизации", ОбъектАвторизации));
			Закрыть(); 
			
		ИначеЕсли Команда.Имя = "Назад" Тогда
			
			Элементы.СтраницыОсновные.ТекущаяСтраница = Элементы.СтраницаТовары;
			Элементы.СтраницыКнопки.ТекущаяСтраница   = Элементы.СтраницаКнопкиНазадДалееОтмена;
			Элементы.КнопкаДалееСтраницаНазадДалееОтмена.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТаблицуТоварыПоДаннымКорзины(АдресКорзиныВХранилище)
	
	ДанныеКорзины = ПолучитьИзВременногоХранилища(АдресКорзиныВХранилище);
	
	Если ДанныеКорзины = Неопределено ИЛИ ДанныеКорзины.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеКорзины.НоменклатураНабора,
	|	ДанныеКорзины.ХарактеристикаНабора,
	|	ДанныеКорзины.Номенклатура,
	|	ДанныеКорзины.Характеристика,
	|	ДанныеКорзины.Упаковка,
	|	ДанныеКорзины.КоличествоУпаковок,
	|	ДанныеКорзины.Цена,
	|	ДанныеКорзины.Сумма,
	|	ДанныеКорзины.СуммаНДС,
	|	ДанныеКорзины.СуммаСНДС,
	|	ДанныеКорзины.Количество,
	|	ДанныеКорзины.ВидЦены,
	|	ДанныеКорзины.СтавкаНДС,
	|	ДанныеКорзины.КОформлению,
	|	ДанныеКорзины.ПодакцизныйТовар
	|ПОМЕСТИТЬ ДанныеКорзины
	|ИЗ
	|	&ДанныеКорзины КАК ДанныеКорзины
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеКорзины.НоменклатураНабора,
	|	ДанныеКорзины.ХарактеристикаНабора,
	|	ДанныеКорзины.Номенклатура,
	|	ДанныеКорзины.Характеристика,
	|	ДанныеКорзины.Упаковка,
	|	ДанныеКорзины.Номенклатура.НаименованиеПолное КАК НаименованиеНоменклатурыПолное,
	|	ДанныеКорзины.Характеристика.НаименованиеПолное КАК НаименованиеХарактеристикиПолное,
	|	ДанныеКорзины.Номенклатура.ВариантОформленияПродажи КАК ВариантОформленияПродажи,
	|	ДанныеКорзины.КоличествоУпаковок,
	|	ДанныеКорзины.Цена,
	|	ДанныеКорзины.Сумма,
	|	ДанныеКорзины.СуммаНДС,
	|	ДанныеКорзины.СуммаСНДС КАК СуммаСНДС,
	|	ДанныеКорзины.Количество,
	|	ДанныеКорзины.ВидЦены,
	|	ДанныеКорзины.СтавкаНДС,
	|	ДанныеКорзины.ПодакцизныйТовар,
	|	ВЫБОР
	|		КОГДА &СкладЯвляетсяГруппойСкладов 
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|		КОГДА СпрНоменклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|			ТОГДА &Склад
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|	КОНЕЦ КАК Склад,
	|	Выразить("""" КАК Строка(1000)) КАК Содержание
	|ИЗ
	|	ДанныеКорзины КАК ДанныеКорзины
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ДанныеКорзины.Номенклатура = СпрНоменклатура.Ссылка
	|ГДЕ
	|	ДанныеКорзины.КОформлению
	|	И ДанныеКорзины.Цена > 0
	|	И ВЫБОР
	|			КОГДА &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяЕНВД)
	|				ТОГДА ДанныеКорзины.ПодакцизныйТовар = ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ";
	
	Запрос.УстановитьПараметр("ДанныеКорзины",ДанныеКорзины);
	Запрос.УстановитьПараметр("НалогообложениеНДС",НалогообложениеНДС);
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("СкладЯвляетсяГруппойСкладов",СкладЯвляетсяГруппойСкладов);
	
	ТаблицаДанныеКорзины = Запрос.Выполнить().Выгрузить();
	
	Для каждого ТекСтрока Из ТаблицаДанныеКорзины Цикл
	
		Если ТекСтрока.ВариантОформленияПродажи = Перечисления.ВариантыОформленияПродажи.АктВыполненныхРабот Тогда
			ТекСтрока.Содержание = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ТекСтрока.НаименованиеНоменклатурыПолное, 
				ТекСтрока.НаименованиеХарактеристикиПолное);
			
		КонецЕсли;
	
	КонецЦикла;
	
	ОтобранныеТоварыРассчитанныеСкидки.Загрузить(ТаблицаДанныеКорзины);
	
	Если НЕ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		РассчитатьСкидки();
	Иначе
		СуммаДокумента = ОтобранныеТоварыРассчитанныеСкидки.Итог("СуммаСНДС");
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию 
		ИЛИ  ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным) Тогда
		
		ЭтапыОплатыСервер.ЗаполнитьЭтапыОплатыДокументаПродажи(
			ЗаполнитьСтруктуруПоРеквизитамФормы(),
			ЗначениеЗаполнено(Соглашение),
			ЗначениеЗаполнено(ГрафикОплаты),
			СуммаДокумента);
		
	КонецЕсли;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОформитьЗаказ()

	СамообслуживаниеСервер.ОформитьЗаказ(ЗаполнитьСтруктуруПоРеквизитамФормы(),
	                                    ?(ВариантОформленияЗаказа = 1, Истина, Ложь));

КонецПроцедуры 

#Область Доставка

&НаСервере
Процедура ЗаполнитьУстановитьРеквизитыДоставкиСервер(ИмяЭлементаФормы);
	
	Если ИспользоватьУправлениеДоставкой Тогда
		РеквизитыДоставки = ДоставкаТоваровКлиентСервер.ПолучитьПустуюСтруктуруРеквизитовДоставки();
		РеквизитыДоставки.Вставить("Партнер", Партнер);
		РеквизитыДоставки.Вставить("Ссылка",  Документы.ЗаказКлиента.ПустаяСсылка());
		ЗаполнитьЗначенияСвойств(РеквизитыДоставки, ЭтаФорма);
		ДоставкаТоваров.ЗаполнитьРеквизитыДоставки(Элементы, ИмяЭлементаФормы, РеквизитыДоставки);
		ЗаполнитьЗначенияСвойств(ЭтаФорма, РеквизитыДоставки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактноеЛицоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", Партнер);
	ПараметрыФормыВыбора = Новый Структура("Отбор", СтруктураОтбора);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("Справочник.КонтактныеЛицаПартнеров.ФормаВыбора", ПараметрыФормыВыбора, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		КонтактноеЛицо = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНоменклатуры()

	ТекущиеДанные = Элементы.ОтобранныеТоварыРассчитанныеСкидки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", ТекущиеДанные.Номенклатура);
		ОткрытьФорму("Справочник.Номенклатура.Форма.ФормаЭлемента", ПараметрыФормы);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
