﻿
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область АктОРасхождениях

Процедура ЗаполнитьЗаказИСкладВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);

	НайденныеСтроки = ДокументыОснования.НайтиСтроки(Новый Структура("Реализация", СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание]));
	Если НайденныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки[0];
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары[ИменаРеквизитовАкта.Заказ]) Тогда
		Если НайденнаяСтрока.ЗаказыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары[ИменаРеквизитовАкта.Заказ] = НайденнаяСтрока.ЗаказыОснования.Получить(0).Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары.Склад) Тогда
		Если НайденнаяСтрока.СкладыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары.Склад = НайденнаяСтрока.СкладыОснования.Получить(0).Значение;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицыТовары.Назначение) Тогда
		СтрокаТаблицыТовары.Назначение = НайденнаяСтрока.Назначение;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковок(СтруктураДействий, Объект) Экспорт
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуРасхождения");
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.АктОРасхожденияхПослеОтгрузки") Тогда
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеОтгрузки");
	Иначе
		СтруктураДействий.Вставить("ПересчитатьРасхожденияПослеПриемки");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументОснованиеВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);

	Если Не СтрокаТаблицыТовары[ИменаРеквизитовАкта.ЗаполненоПоОснованию] И Не ЗначениеЗаполнено(СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание]) Тогда
		Если ДокументыОснования.Количество() = 1 Тогда
			СтрокаТаблицыТовары[ИменаРеквизитовАкта.Основание] = ДокументыОснования[0].Реализация;
			УстановитьПризнакДокументОснованиеПоЗаказу(СтрокаТаблицыТовары, ДокументыОснования[0], ЭтоАктОРасхожденияПослеОтгрузки);
			ЗаполнитьЗаказИСкладВСтроке(СтрокаТаблицыТовары, ДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьПризнакДокументОснованиеПоЗаказу(СтрокаТаблицыТовары, СтрокаДокументыОснования, ЭтоАктОРасхожденияПослеОтгрузки) Экспорт
	
	ИменаРеквизитовАкта = РасхожденияКлиентСервер.ИменаРеквизитовВЗависимостиОтТипаАкта(ЭтоАктОРасхожденияПослеОтгрузки);
	
	СтрокаТаблицыТовары[ИменаРеквизитовАкта.ОснованиеПоЗаказам] = (СтрокаДокументыОснования.ЗаказыОснования.Количество() > 0);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура УстановитьОтборСпискаПоКонтактномуЛицу(Форма) Экспорт

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	                                Форма.Список, "КонтактноеЛицо", Форма.КонтактноеЛицоОтбор,
	                                ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Форма.КонтактноеЛицоОтбор));

КонецПроцедуры

// Процедура рассчитывает комиссионное вознаграждение.
//
// Параметры
//  Объект  - ДанныеФормыСтруктура - документ, для которого рассчитывается вознаграждение
//
Процедура РассчитатьСуммуВознаграждения(Объект) Экспорт
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		
		Если Объект.СпособРасчетаВознаграждения = 
			   ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтРазностиСуммыПродажиИСуммыКомитента") Тогда
			СтрокаТоваров.СуммаВознаграждения = (СтрокаТоваров.СуммаПродажи - СтрокаТоваров.СуммаСНДС) * Объект.ПроцентВознаграждения / 100;
			
		ИначеЕсли Объект.СпособРасчетаВознаграждения = 
			   ПредопределенноеЗначение("Перечисление.СпособыРасчетаКомиссионногоВознаграждения.ПроцентОтСуммыПродажи") Тогда
			СтрокаТоваров.СуммаВознаграждения = СтрокаТоваров.СуммаПродажи * Объект.ПроцентВознаграждения / 100;
			
		Иначе
			СтрокаТоваров.СуммаВознаграждения = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Объект.СуммаВознаграждения = Объект.Товары.Итог("СуммаВознаграждения");
	
	ПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(Объект.СтавкаНДСВознаграждения);
	Объект.СуммаНДСВознаграждения = Окр(Объект.СуммаВознаграждения * ПроцентНДС / (1 + ПроцентНДС), 2, РежимОкругления.Окр15как20);
	
КонецПроцедуры

// Получает хозяйственную операцию договора по хозяйственной операции заявки на возврат
//
// Параметры
//  ХозяйственнаяОперация  - ПеречислениеСсылка.ХозяйственныеОперации - операция заявки на возврат
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ХозяйственныеОперации - операция договора
//
Функция ХозяйственнаяОперацияДоговора(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияВРозницу");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровОтКлиента") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
	ИначеЕсли ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОтКомиссионера") Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию");
	Иначе
		Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
	КонецЕсли;
	
КонецФункции

// Добавляет общие действия для обычной формы и формы самообслуживания документа Заявка на возврат товаров от клиента
//
// Параметры
//  СтруктураДействий  - Структура - структура, в которую добавляются действия
//  Объект  - ДокументОбъект.ЗаявкаНаВозвратТоваротОтКлиента - документ, в котором выполняются действия
//
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокВозвращаемыеТоварыОбщее(СтруктураДействий, Объект) Экспорт
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСумму");
	
КонецПроцедуры

// Добавляет действия при изменнии количества упаковок для обычной формы и формы самообслуживания документа Отчет комиссионера
//
// Параметры
//  СтруктураДействий  - Структура - структура, в которую добавляются действия
//  Объект  - ДокументОбъект.ОтчетКомиссионера - документ, в котором выполняются действия
//
Процедура ДобавитьВСтруктуруДействияПриИзмененииКоличестваУпаковокОтчетКомиссионера(СтруктураДействий, Объект) Экспорт
	
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС",  ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
	СтруктураДействий.Вставить("ПересчитатьСумму");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", Объект.ЦенаВключаетНДС));
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажи");
	СтруктураДействий.Вставить("ПересчитатьСуммуПродажиНДС");
	СтруктураДействий.Вставить("ОчиститьСуммуВознаграждения");
	
КонецПроцедуры

Процедура УправлениеСтраницамиЮрФизЛицоПриИзменении(Форма, ЮрФизЛицо) Экспорт
	
	Если ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо") Тогда
		Форма.Элементы.СтраницыНаименованиеПолноеКомпанияЧастноеЛицо.ТекущаяСтраница = Форма.Элементы.СтраницаНаименованиеПолноеЧастноеЛицо;
	Иначе
		Форма.Элементы.СтраницыНаименованиеПолноеКомпанияЧастноеЛицо.ТекущаяСтраница = Форма.Элементы.СтраницаНаименованиеПолноеКомпания;
	КонецЕсли;
	
	Форма.Элементы.Пол.Доступность          = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));
	Форма.Элементы.ДатаРождения.Доступность = (ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ФизЛицо"));

КонецПроцедуры

// Устанавливает доступность кнопки заполнения КПП по ИНН и виду контрагента.
// Кнопка недоступна, если не заполнен ИНН
//
// Параметры
//  Форма                                 - УправляемаяФорма - форма, для которой выполняются действия.
//  ЮрФизЛицо                             - Перечисление.ЮрФизЛицо - вид контрагента.
//  ИНН                                   - Строка - значение ИНН контрагента.
//  ЭтоОбособленноеПодразделение          - Булево - признак того, что этого обособленное подразделение.
//  НастройкиПодключенияКСервисуИППЗаданы - Булево - признак того, что настройки к сервису интернет.
//  КнопкаНедоступнаБезусловно            - Булево - признак того, что кнопка не доступна безусловно.
//  ПостфиксИмениЭлементаФормы            - Строка - добавляется к стандартному имени обрабатываемого элемента формы.
//
Процедура УстановитьДоступностьКнопкиЗаполнитьПоИНН(Форма, 
	                                                ЮрФизЛицо,
	                                                ИНН,
	                                                ЭтоОбособленноеПодразделение,
	                                                НастройкиПодключенияКСервисуИППЗаданы,
	                                                КнопкаНедоступнаБезусловно = Ложь,
	                                                ПостфиксИмениЭлементаФормы = "") Экспорт
	
	ЭтоЮрЛицо = ОбщегоНазначенияУТКлиентСервер.ЭтоЮрЛицо(ЮрФизЛицо);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ЗаполнитьПоИНН" + ПостфиксИмениЭлементаФормы,
		"Доступность",
		(Не КнопкаНедоступнаБезусловно) 
		  И НастройкиПодключенияКСервисуИППЗаданы 
		  И ЭтоЮрЛицо И Не ПустаяСтрока(ИНН) 
		  И Не ЭтоОбособленноеПодразделение);
		  
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ЗаполнитьПоИННФизЛицо",
		"Доступность",
		(Не КнопкаНедоступнаБезусловно) 
		  И НастройкиПодключенияКСервисуИППЗаданы 
		  И ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ИндивидуальныйПредприниматель") 
		  И Не ПустаяСтрока(ИНН));
		
КонецПроцедуры

// Устанавливает доступность кнопки заполнения реквизтов контрагента по наименованию.
// Кнопка доступна если контрагент юр.лицо и есть подключени к интернет-поддержке
//
// Параметры
//  Форма                                 - УправляемаяФорма - форма, для которой выполняются действия.
//  ЮрФизЛицо                             - Перечисление.ЮрФизЛицо - вид контрагента.
//  СокрЮрНаименование                    - Строка - наименование контрагента.
//  ЭтоОбособленноеПодразделение          - Булево - признак того, что этого обособленное подразделение.
//  НастройкиПодключенияКСервисуИППЗаданы - Булево - признак того, что настройки к сервису интернет
//  ИмяЭлементаФормы                      - Строка - имя элемента формы, если отлично от стандартного
//
Процедура УстановитьДоступностьКнопкиЗаполнитьПоСокрНаименованию(Форма, 
	                                                             ЮрФизЛицо,
	                                                             СокрЮрНаименование,
	                                                             ЭтоОбособленноеПодразделение,
	                                                             НастройкиПодключенияКСервисуИППЗаданы,
	                                                             ИмяЭлементаФормы = "ЗаполнитьПоНаименованиюПоДаннымЕдиныхГосРеестров") Экспорт
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		ИмяЭлементаФормы,
		"Доступность",
		 НастройкиПодключенияКСервисуИППЗаданы 
		  И ЮрФизЛицо = ПредопределенноеЗначение("Перечисление.ЮрФизЛицо.ЮрЛицо") 
		  И Не ПустаяСтрока(СокрЮрНаименование) 
		  И Не ЭтоОбособленноеПодразделение);
	
КонецПроцедуры

Функция ЭтоИНН(СтрокаИНН) Экспорт
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции

// Проверяет необходимые условия для подключения к сервису получения данных контрагентов по ИНН.
//
// Параметры:
//  ИННЗаполненКорректно                   - Булево - признак того, что ИНН, по которому будут получены данные корректен.
//  НастройкиПодключенияКСервисуИППЗаданы  - Булево - признак того, что в настройках программы заданы настройки подключения к сервису.
//        интернет поддержки пользователей.
//  ЭтоЮрлицо                             - Булево - признак того, что контрагент является юридическим лицом.
//  ЭтоИндивидуальныйПредприниматель      - Булево - признак того, что контрагент является индивидуальным предпренимателем.
//  ОбособленноеПодразделение             - Булево - признак того, что контрагент является обособленным подразделением.
//
// Возвращаемое значение:
//   Булево   - Истина, если заполнение возможно, Ложь в обратно случае.
//
Функция ЗаполнениеРеквизитовПоДаннымИННВозможно(ИННЗаполненКорректно,
	                                            НастройкиПодключенияКСервисуИППЗаданы,
	                                            ЭтоЮрлицо,
	                                            ЭтоИндивидуальныйПредприниматель,
	                                            ОбособленноеПодразделение) Экспорт
	
	Возврат ИННЗаполненКорректно И НастройкиПодключенияКСервисуИППЗаданы
	        И (ЭтоЮрлицо ИЛИ ЭтоИндивидуальныйПредприниматель) И Не ОбособленноеПодразделение; 
	
КонецФункции

#КонецОбласти

#КонецОбласти
